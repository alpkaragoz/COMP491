import 'package:coach_connect/models/user_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CoachHomeViewModel extends ChangeNotifier {
  UserAccount? user;
  CoachHomeViewModel(this.user);

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
