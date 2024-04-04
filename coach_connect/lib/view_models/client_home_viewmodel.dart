import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClientHomeViewModel extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners(); 
  }
}
