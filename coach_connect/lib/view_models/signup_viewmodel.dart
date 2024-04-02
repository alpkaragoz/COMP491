import '../mvvm/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coach_connect/models/user_account.dart';

class SignupViewModel extends EventViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String accountType = 'client'; // default to 'client'
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String returnMessage = "";

  Future<bool> signup() async {
    if (!validate()) {
      return false; // Stop the signup if validation fails
    }
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (credential.user?.uid != null) {
        final newUser = UserAccount(
          credential.user!.uid,
          nameController.text,
          emailController.text,
          int.tryParse(ageController.text) ?? 0,
          accountType,
          [], // Empty list for coaches' IDs
          [], // Empty list for workouts' IDs
        );
        await _db.collection('users').doc(credential.user?.uid).set(newUser.toMap());
        clearFields();
        returnMessage = 'Account created, logging you in.';
        return true;
        // Navigate to next screen or show a success message here.
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        returnMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        returnMessage = 'The account already exists for that email.';
      }
    } catch (e) {
      returnMessage = 'Unknown error.';
    }
    return false;
  }

  bool validate() {
    returnMessage = 'Please check all fields.';

    if (emailController.text.isEmpty) {
      returnMessage = 'Email cannot be empty.';
      return false;
    }
    if (passwordController.text.isEmpty) {
      returnMessage = 'Password cannot be empty.';
      return false;
    }
    if (nameController.text.isEmpty) {
      returnMessage = 'Name cannot be empty.';
      return false;
    }
    if (ageController.text.isEmpty) {
      returnMessage = 'Age cannot be empty.';
      return false;
    }
    return true;
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    ageController.clear();
  }
}
