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
      print("error during getting user data $e");
    }
    return null;
  }

  Future<void> addWorkoutId(String userId) async {
    try {
      final id = Uuid().v4();
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "workoutIds": FieldValue.arrayUnion([id])
      });
      await FirebaseFirestore.instance
          .collection("workouts")
          .doc(id)
          .set({"id": id});
    } catch (e) {
      print("asdasda $e");
    }
  }
}
