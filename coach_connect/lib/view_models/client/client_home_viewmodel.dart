import 'package:coach_connect/models/user_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClientHomeViewModel extends ChangeNotifier {
  UserAccount? user;
  ClientHomeViewModel(this.user);

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
