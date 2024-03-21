import 'package:coach_connect/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key, required this.user});

  final UserCredential user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome ${user.user!.email}"),
          ElevatedButton(onPressed: ()async{await FirebaseAuth.instance.signOut();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
}, child: Text("Logout"))
        ],
      ),),
    );
  }
}