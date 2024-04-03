import 'package:coach_connect/service/auth.dart';
import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final AuthenticationService _auth = AuthenticationService();
  String _accountType = 'client'; // default to 'client'
  (bool, String) _result = (false, "");
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String get accountType => _accountType;
  (bool, String) get result => _result;

  set accountType(String newValue) {
    if (_accountType != newValue) {
      _accountType = newValue;
      notifyListeners();
    }
  }

  Future<bool> signup() async {
    if (!_validate()) {
      return false; // Stop the signup if validation fails
    }
    _isLoading = true;
    notifyListeners();
    _result = (await _auth.signUpWithEmail(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        age: int.tryParse(ageController.text) ?? 0,
        accountType: _accountType));
    _isLoading = false;
    notifyListeners();
    return _result.$1;
  }

  bool _validate() {
    _result = (false, 'Please check all fields.');

    if (emailController.text.isEmpty) {
      _result = (false, 'Email cannot be empty.');
      return false;
    }
    if (passwordController.text.isEmpty) {
      _result = (false, 'Password cannot be empty.');
      return false;
    }
    if (nameController.text.isEmpty) {
      _result = (false, 'Name cannot be empty.');
      return false;
    }
    if (ageController.text.isEmpty) {
      _result = (false, 'Age cannot be empty.');
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    ageController.clear();
  }
}
