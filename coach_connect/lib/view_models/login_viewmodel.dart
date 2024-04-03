import 'package:flutter/material.dart';
import 'package:coach_connect/service/auth.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthenticationService _auth = AuthenticationService();
  bool _isLoading = false;
  String _returnMessage = "";

  Future<void> login() async {
    _isLoading = true;
    notifyListeners();
    _returnMessage = await _auth.signInWithEmail(
        email: usernameController.text,
        password: passwordController.text) as String;
    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  String get returnMessage => _returnMessage;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
