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
      required AccountType accountType,
      required String username}) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;

    // First, check if the username is already taken
    DocumentSnapshot usernameSnapshot =
        await _db.collection('usernames').doc(username).get();
    if (usernameSnapshot.exists) {
      return (false, "Username is already taken.");
    }

    UserCredential? credential; // Initialize to null

    try {
      // Create user with FirebaseAuth
      credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserAccount newUser = UserAccount(
        credential.user!.uid,
        name,
        email,
        age,
        accountType,
        username,
        "", // Empty string for coach ID
        [], // Empty list for client IDs
        [], // Empty list for workout IDs
      );

      // Perform a batch write to ensure atomicity
      WriteBatch batch = _db.batch();
      batch.set(
          _db.collection('users').doc(credential.user!.uid), newUser.toMap());
      batch.set(_db.collection('usernames').doc(username),
          {'userId': credential.user!.uid});
      await batch.commit();

      return (true, "Account created.");
    } catch (e) {
      // If an error occurs and a user was created, attempt to delete the user
      if (credential?.user != null) {
        await credential!.user!.delete();
      }

      // Handle specific FirebaseAuthException errors
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          return (false, "The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          return (false, "The account already exists for that email.");
        }
      }
      // Return a generic error message if the exception is not a FirebaseAuthException
      return (false, e.toString());
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
