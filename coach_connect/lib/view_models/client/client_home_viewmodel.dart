import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_connect/models/day.dart';
import 'package:coach_connect/models/request.dart';
import 'package:coach_connect/models/user_account.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/service/auth.dart';

class ClientHomeViewModel extends ChangeNotifier {
  final AuthenticationService _auth = AuthenticationService();
  UserAccount user;
  ClientHomeViewModel(this.user);
  Request? pendingRequest;
  String currentCoachName = "";

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<String> refreshUserData() async {
    try {
      UserAccount updatedUser = await _auth.getCurrentUserAccountObject();
      user = updatedUser;
      await refreshCoach(user.coachId);
      notifyListeners();
      return "Successfully fetched user.";
    } catch (e) {
      return "Failed to get user.";
    }
  }

  Future<void> refreshCoach(String coachId) async {
    if (coachId.isEmpty) {
      return;
    }
    UserAccount? currentCoach = await _auth.getUserAccountObject(coachId);
    if (currentCoach == null) {
      return;
    }
    currentCoachName = currentCoach.username;
  }

  Future<void> getUserAccountOfRequest() async {
    pendingRequest = null;
    notifyListeners();
    try {
      pendingRequest = await _auth.getRequestObjectForClient();
      notifyListeners();
    } catch (e) {
      // No request found.
    }
  }

  Future<String> cancelRequestFromClientToCoach() async {
    if (pendingRequest == null) {
      return "No request to cancel.";
    }
    var message = await _auth.cancelRequestFromClientToCoach(pendingRequest!);
    await getUserAccountOfRequest();
    notifyListeners();
    return message;
  }

  Future<String> sendRequestToCoach(String coachUsername) async {
    if (coachUsername.isEmpty) {
      return ("Coach username cannot be empty.");
    }
    try {
      var message = await _auth.sendRequestToCoach(coachUsername);
      await getUserAccountOfRequest();
      notifyListeners();
      return message;
    } catch (e) {
      return ("Failed to send request to coach: $e");
    }
  }

  Future<void> removeCoachFromClient(
      {required String clientId, required String coachId}) async {
    final clientRef =
        FirebaseFirestore.instance.collection('users').doc(clientId);
    final coachRef =
        FirebaseFirestore.instance.collection('users').doc(coachId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(clientRef, {'coachId': FieldValue.delete()});
        transaction.update(coachRef, {
          'clientIds': FieldValue.arrayRemove([clientId])
        });
      });
    } catch (e) {
      return;
    }
  }

  Future<List<String>> getWorkouts() async {
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .get();
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
      final workoutDoc = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .get();
      if (workoutDoc.exists) {
        return workoutDoc.data();
      }
    } catch (e) {
      print("Error fetching workout: $e");
    }
    return null;
  }

  Future<List<DayModel>> getDays(String workoutId, String weekId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .get();
      return snapshot.docs.map((doc) => DayModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error fetching days: $e');
      return [];
    }
  }


}
