import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_connect/pages/client_home_page.dart'; 
import 'package:coach_connect/pages/coach_home_page.dart'; 

class HomePageNavigator extends StatelessWidget {
  const HomePageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming 'users' is your collection where user profiles are stored
    // and each user document has an 'accountType' field that stores the user's role
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Scaffold(body: Center(child: Text('Error fetching user data')));
            }
            if (snapshot.hasData) {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              String accountType = userData['accountType'] ?? 'client';
              // Navigate to the appropriate home page based on the account type
              switch (accountType) {
                case 'coach':
                  return const CoachHomePage(); // Your CoachHomePage widget here
                case 'client':
                default:
                  return const ClientHomePage(); // Your ClientHomePage widget here
              }
            } else {
              return const Scaffold(body: Center(child: Text('No user data available')));
            }
          }
          // Show a loading spinner while waiting for the user data
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    } else {
      return const Scaffold(body: Center(child: Text('No user logged in')));
    }
  }
}
