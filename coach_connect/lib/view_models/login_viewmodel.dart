import 'package:flutter/material.dart';
import 'package:coach_connect/service/auth.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthenticationService _auth = AuthenticationService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<(bool, String)> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final result =
        await _auth.signInWithEmail(email: email, password: password);
    _isLoading = false;
    notifyListeners();
    return (result.$1, result.$2);
  }
}
