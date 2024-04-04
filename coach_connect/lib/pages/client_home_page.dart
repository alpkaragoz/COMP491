
// client_homepage.dart

import 'package:flutter/material.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({Key? key}) : super(key: key);

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  final elevatedButtonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(color: Colors.black),
    backgroundColor: Colors.blue,
  );

  final redElevatedButtonStyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(color: Colors.black),
    backgroundColor: Colors.red,
  );

  String clientName = 'Janice Johan'; // Replace with actual client name from firebase later on after getting clients

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coach Connect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Coach Connect'),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome, $clientName',
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: elevatedButtonStyle,
                      onPressed: () {
                        // TODO: Implement My Workouts functionality
                      },
                      child: const Text('My Workouts'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: elevatedButtonStyle,
                      onPressed: () {
                        // TODO: Implement Connect functionality
                      },
                      child: const Text('Connect'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: elevatedButtonStyle,
                      onPressed: () {
                        // TODO: Implement Clients functionality
                      },
                      child: const Text('My Coach'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: elevatedButtonStyle,
                      onPressed: () {
                        // TODO: Implement Settings functionality
                      },
                      child: const Text('Settings'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: redElevatedButtonStyle,
                      onPressed:onPressed: _signOut,
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut(); }
 }
