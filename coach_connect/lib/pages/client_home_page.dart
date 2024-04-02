import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    // Get the current user
    user = FirebaseAuth.instance.currentUser;
    // Optionally, if you need to force a refresh or make sure you have the latest user info, you can reload the user
    user?.reload();
    // After reload, ensure you access the current user again as it might be updated
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (user != null) ...[
              Text('Welcome, ${user!.email}'),
              // Add more user information or options here
            ],
            ElevatedButton(
              onPressed: _signOut,
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
