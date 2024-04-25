import 'package:coach_connect/models/request.dart';
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

  Future<(bool, String)> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return (true, "Signed out successfully.");
    } catch (e) {
      return (false, "Failed to sign out: ${e.toString()}");
    }
  }

  Future<Request> getRequestObjectForClient() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }
      final query = _db
          .collection("requests")
          .where("senderId", isEqualTo: currentUser.uid);
      final querySnapshot = await query.get();

      var request = Request.fromJson(
          querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      return request;
    } catch (e) {
      throw Exception('Error occurred while fetching receiver user account');
    }
  }

  Future<String> cancelRequestFromClientToCoach(Request request) async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return "No user logged in.";
    }

    try {
      // Use the Request object's 'id' to directly access and delete the document
      await _db.collection('requests').doc(request.id).delete();
      return "Request cancelled successfully.";
    } catch (e) {
      return "Error cancelling request: $e";
    }
  }

  Future<String> sendRequestToCoach(String coachUsername) async {
    try {
      UserAccount currentUser = await getCurrentUserAccountObject();
      // Find receiverId by querying for a user with the provided coachUsername
      var users = await _db
          .collection('users')
          .where('username', isEqualTo: coachUsername)
          .limit(1)
          .get();

      if (users.docs.isEmpty) {
        return ("No user found with the username: $coachUsername");
      }

      // Assuming the first document found is the correct user
      var receiverId = users.docs.first.id;

      // Create a request in the 'requests' collection
      await _db.collection('requests').add({
        'senderId': currentUser.id,
        'receiverId': receiverId,
        'senderUsername': currentUser.username,
        'receiverUsername': coachUsername,
      });
      return ("Request to add coach sent successfully.");
    } catch (e) {
      return ("Error sending request: $e");
    }
  }

  Future<List<Request?>> getPendingRequestsForCoach() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return [];
    }

    try {
      // Query Firestore for requests where the current user is the receiver
      final querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('receiverId', isEqualTo: user.uid)
          .get();

      // Map the documents to Request objects
      List<Request?> requests = querySnapshot.docs.map((doc) {
        return Request.fromJson(doc.data(), doc.id);
      }).toList();

      return requests;
    } catch (e) {
      return [];
    }
  }

  Future<List<UserAccount?>> getClientObjectsForCoach() async {
    try {
      UserAccount currentUser = await getCurrentUserAccountObject();

      // Fetch each client document by their ID
      List<UserAccount?> clients = [];
      for (String clientId in currentUser.clientIds) {
        var client = await getUserAccountObject(clientId);
        clients.add(client);
      }
      return clients;
    } catch (e) {
      return []; // Return an empty list on error
    }
  }
}
