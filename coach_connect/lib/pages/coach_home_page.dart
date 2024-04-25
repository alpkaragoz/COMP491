import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({Key? key}) : super(key: key);

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  bool _useOrangeBlackTheme = false;
  
  ThemeData get appTheme => _useOrangeBlackTheme ? ThemeData(
    primarySwatch: Colors.orange,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Colors.orange,
        onPrimary: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      headline6: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      bodyText2: TextStyle(fontSize: 16, color: Colors.black87),
    ),
  ) : ThemeData(
    primarySwatch: Colors.blue,
    textTheme: const TextTheme(
      headline6: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      bodyText2: TextStyle(fontSize: 16, color: Colors.black87),
    ),
  );

  ButtonStyle getElevatedButtonStyle(Color bgColor) {
    return ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 16, color: Colors.white),
      backgroundColor: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String clientName = 'Janice Johan'; // Replace with actual client name from firebase later on after getting clients

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coach Connect',
      theme: appTheme,
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
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 32),
              // Existing buttons here...
              ElevatedButton(
                style: getElevatedButtonStyle(Theme.of(context).primaryColor),
                onPressed: () {
                  // TODO: Implement My Workouts functionality
                },
                child: const Text('My Workouts'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: getElevatedButtonStyle(Theme.of(context).primaryColor),
                onPressed: () {
                  // TODO: Implement Connect functionality
                },
                child: const Text('Connect'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: getElevatedButtonStyle(Theme.of(context).primaryColor),
                onPressed: () {
                  // TODO: Implement My Coach functionality
                },
                child: const Text('My Coach'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: getElevatedButtonStyle(Theme.of(context).primaryColor),
                onPressed: () {
                  // TODO: Implement Settings functionality
                },
                child: const Text('Settings'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: getElevatedButtonStyle(Colors.red),
                onPressed: _signOut,
                child: const Text('Logout'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: getElevatedButtonStyle(Colors.grey),
                onPressed: () {
                  setState(() {
                    _useOrangeBlackTheme = !_useOrangeBlackTheme;
                  });
                },
                child: Text(_useOrangeBlackTheme ? 'Switch to Blue Theme' : 'Switch to Orange & Black Theme'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
