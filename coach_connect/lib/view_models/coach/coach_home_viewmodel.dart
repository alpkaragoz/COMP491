import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_connect/models/request.dart';
import 'package:coach_connect/models/user_account.dart';
import 'package:coach_connect/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CoachHomeViewModel extends ChangeNotifier {
  UserAccount? user;
  CoachHomeViewModel(this.user);
  final AuthenticationService _auth = AuthenticationService();
  List<UserAccount?> clients = [];
  List<Request?> requests = [];

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<String> refreshUserData() async {
    try {
      UserAccount updatedUser = await _auth.getCurrentUserAccountObject();
      user = updatedUser;
      notifyListeners();
      return "Successfully fetched user.";
    } catch (e) {
      return "Failed to get user.";
    }
  }

  Future<void> getClientObjectsForCoach() async {
    clients = await _auth.getClientObjectsForCoach();
    notifyListeners();
  }

  Future<void> getPendingRequestsForCoach() async {
    requests = await _auth.getPendingRequestsForCoach();
    notifyListeners();
  }

  Future<String> acceptRequest(Request request) async {
    var message = await _auth.acceptRequest(request);
    await getClientObjectsForCoach();
    await getPendingRequestsForCoach();
    notifyListeners();
    return message;
  }

  String denyRequest(Request request) {
    return "";
  }

  Future<UserAccount?> getUser(String id) async {
    try {
      final user = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: id)
          .get();
      if (user.docs.isNotEmpty) {
        final userData = user.docs.first.data();
        final userModel = UserAccount.fromJson(userData);
        return userModel;
      }
    } catch (e) {
      print("Error during getting user data: $e");
    }
    return null;
  }

  Future<List<String>> getWorkouts(String clientId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(clientId).get();
      if (userDoc.exists) {
        final workoutIds = List<String>.from(userDoc.data()?['workoutIds'] ?? []);
        return workoutIds;
      }
    } catch (e) {
      print("Error fetching workouts: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>?> getWorkout(String workoutId) async {
    try {
      final workoutDoc = await FirebaseFirestore.instance.collection('workouts').doc(workoutId).get();
      if (workoutDoc.exists) {
        return workoutDoc.data();
      }
    } catch (e) {
      print("Error fetching workout: $e");
    }
    return null;
  }

  Future<void> addWorkoutId(String clientId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(clientId).get();
      final workoutIds = List<String>.from(userDoc.data()?['workoutIds'] ?? []);
      final newWorkoutName = 'Workout ${workoutIds.length + 1}';
      final id = Uuid().v4();

      await FirebaseFirestore.instance.collection('users').doc(clientId).update({
        'workoutIds': FieldValue.arrayUnion([id]),
      });

      await FirebaseFirestore.instance.collection('workouts').doc(id).set({
        'id': id,
        'name': newWorkoutName, // Set the new workout name
      });
    } catch (e) {
      print("Error adding workout: $e");
    }
  }
}
