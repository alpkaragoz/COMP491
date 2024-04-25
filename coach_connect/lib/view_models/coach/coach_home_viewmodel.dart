import 'dart:async';

import 'package:coach_connect/models/request.dart';
import 'package:coach_connect/models/user_account.dart';
import 'package:coach_connect/service/auth.dart';
import 'package:flutter/material.dart';

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

  String acceptRequest(String requestId) {
    return "";
  }

  String denyRequest(String requestId) {
    return "";
  }
}
