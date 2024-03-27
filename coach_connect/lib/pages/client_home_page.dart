import 'package:coach_connect/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key, required this.user});

  final UserCredential user;

  @override
  State<ClientHomePage> createState() => ClientHomePageState();
}

class ClientHomePageState extends State<ClientHomePage> {
  Future<void> _signOutAndNavigate() async {
    await FirebaseAuth.instance.signOut();

    // Use "mounted" to check if the widget is still in the widget tree
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome ${widget.user.user!.email}"),
            ElevatedButton(
              onPressed: _signOutAndNavigate,
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
