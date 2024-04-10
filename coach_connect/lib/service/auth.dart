import 'package:coach_connect/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_connect/models/user_account.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthenticationService();
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<(bool, String)> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return (true, "Signing in.");
    } on FirebaseAuthException catch (e) {
      return (false, e.message ?? "Error");
    }
  }

  Future<(bool, String)> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required int age,
      required AccountType accountType}) async {
    String message = "";
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final newUser = UserAccount(
        credential.user!.uid,
        name,
        email,
        age,
        accountType,
        "", // Empty string for coach ID
        [], // Empty list for client IDs
        [], // Empty list for workout IDs
      );
      await _db
          .collection('users')
          .doc(credential.user?.uid)
          .set(newUser.toMap());

      message = 'Account created.';
      return (true, message);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      return (false, message);
    }
  }

// Returns any user object given ID.
  Future<UserAccount?> getUserAccountObject(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return UserAccount.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Gets current UserAccount, throws exception if it cannot.
  Future<UserAccount> getCurrentUserAccountObject() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw FirebaseAuthException(
          code: 'no-current-user', message: 'No current user is signed in.');
    }

    DocumentSnapshot userDoc =
        await _db.collection('users').doc(currentUser.uid).get();
    if (userDoc.exists && userDoc.data() != null) {
      return UserAccount.fromJson(userDoc.data() as Map<String, dynamic>);
    } else {
      throw FirebaseAuthException(
          code: 'user-not-found-in-db',
          message: 'The user details were not found in the database.');
    }
  }
}
