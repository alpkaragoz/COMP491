import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/service/auth.dart';
import 'package:coach_connect/init/languages/locale_keys.g.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  void _signup() async {
    String? result = await _authService.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // Check if the widget is still mounted before navigating
    if (!mounted) return;

    if (result != null) {
      // Handle the signup result
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    } else {
      // Handle the error or show an error message
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Signup failed')));
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
        child: Column(
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
            ElevatedButton(
              onPressed: _signup,
              child: Text(LocaleKeys.signup.tr()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
