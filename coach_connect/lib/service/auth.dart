import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_connect/models/user_account.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthenticationService();

  Future<String> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Unknown error.";
    } catch (e) {
      return "Unknown error.";
    }
  }

  Future<(bool, String)> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required int age,
      required String accountType}) async {
    String message = "";
    try {
      final credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final newUser = UserAccount(
        credential.user!.uid,
        name,
        email,
        age,
        accountType,
        [], // Empty list for coaches' IDs
        [], // Empty list for workouts' IDs
      );
      await _db
          .collection('users')
          .doc(credential.user?.uid)
          .set(newUser.toMap());
      message = 'Account created, logging you in.';
      return (true, message);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }
      return (false, message);
    } catch (e) {
      return (false, 'Unknown error.');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
