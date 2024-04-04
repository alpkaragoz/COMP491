import 'package:flutter/material.dart';
import 'package:coach_connect/models/user_account.dart';
import 'package:coach_connect/service/auth.dart';

class HomeNavigatorViewModel extends ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();
  UserAccount? user;
  bool isLoading = true;
  String? errorMessage;

  HomeNavigatorViewModel() {
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    isLoading = true;
    notifyListeners(); // Notify listeners to show loading indicator
    try {
      user = await _authService.getUserObject();
      errorMessage = null; // Clear any previous error messages
    } catch (e) {
      errorMessage = e.toString();
      user = null; // Ensure user is null if there's an error
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners to update the UI based on the new state
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}
