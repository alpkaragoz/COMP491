import 'package:coach_connect/mvvm/viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends EventViewModel {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String returnMessage = "";

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);
      returnMessage = 'Login succesful.';
    } on FirebaseAuthException catch (e) {
      String? error = e.message;
      returnMessage = 'Login failed. $error';
    }
  }
}
