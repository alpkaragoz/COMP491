import 'package:coach_connect/service/auth.dart';
import 'package:coach_connect/utils/constants.dart';
import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthenticationService _auth = AuthenticationService();
  AccountType _accountType = AccountType.client; // default to 'client'
  (bool, String) _result = (false, "");
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  AccountType get accountType => _accountType;
  (bool, String) get result => _result;

  set accountType(AccountType newValue) {
    if (_accountType != newValue) {
      _accountType = newValue;
      notifyListeners();
    }
  }

  Future<bool> signup(String email, String password, String name, int age,
      String username) async {
    if (!_validate(email, password, name, age, username)) {
      return false; // Stop the signup if validation fails
    }
    _isLoading = true;
    notifyListeners();
    _result = (await _auth.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        age: age,
        accountType: _accountType,
        username: username));
    _isLoading = false;
    notifyListeners();
    return _result.$1;
  }

  bool _validate(
      String email, String password, String name, int age, String username) {
    _result = (false, 'Please check all fields.');

    if (email.isEmpty) {
      _result = (false, 'Email cannot be empty.');
      return false;
    }
    if (password.isEmpty) {
      _result = (false, 'Password cannot be empty.');
      return false;
    }
    if (name.isEmpty) {
      _result = (false, 'Name cannot be empty.');
      return false;
    }
    if (age.isNaN) {
      _result = (false, 'Age cannot be empty.');
      return false;
    }
    if (username.isEmpty) {
      _result = (false, 'Username cannot be empty.');
      return false;
    }
    return true;
  }
}
