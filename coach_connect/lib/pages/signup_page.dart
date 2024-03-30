import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/init/languages/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _accountType = 'client'; // default to 'client'

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void _signup() async {
    if (!validate()) return; // Stop the signup if validation fails
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (credential.user?.uid != null) {
        await _db.collection('users').doc(credential.user?.uid).set({
          'id': credential.user?.uid,
          'name': _nameController.text,
          'email': _emailController.text,
          'age': int.tryParse(_ageController.text) ?? 0,
          'accountType': _accountType,
          'coaches': [],
          'workouts': [],
        });
        _showSnackBar('Account created!');
        // Navigate to next screen or show a success message here.
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return; // Check if the widget is still mounted before navigating
      }

      if (e.code == 'weak-password') {
        _showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.signup.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context)
              .pop(), // This takes the user back to the previous screen
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: LocaleKeys.email.tr()),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: LocaleKeys.password.tr()),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: LocaleKeys.name.tr()),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: LocaleKeys.age.tr()),
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                LocaleKeys.signupAccountTypePrompt.tr(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.client.tr()),
              leading: Radio<String>(
                value: 'client',
                groupValue: _accountType,
                onChanged: (String? value) {
                  setState(() {
                    _accountType = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.coach.tr()),
              leading: Radio<String>(
                value: 'coach',
                groupValue: _accountType,
                onChanged: (String? value) {
                  setState(() {
                    _accountType = value!;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: _signup,
              child: Text(LocaleKeys.signup.tr()),
            ),
          ],
        ),
      ),
    );
  }

    bool validate() {
    if (_nameController.text.isEmpty) {
      _showSnackBar('Name cannot be empty.');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showSnackBar('Email cannot be empty.');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Password cannot be empty.');
      return false;
    }
    if (_ageController.text.isEmpty) {
      _showSnackBar('Age cannot be empty.');
      return false;
    }
    return true;
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}