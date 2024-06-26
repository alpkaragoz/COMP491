import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coach_connect/models/day.dart';
import 'package:coach_connect/models/exercise.dart';
import 'package:coach_connect/models/request.dart';
import 'package:coach_connect/models/set.dart';
import 'package:coach_connect/models/user_account.dart';
import 'package:coach_connect/models/week.dart';
import 'package:coach_connect/models/workout.dart';
import 'package:coach_connect/service/auth.dart';
import 'package:flutter/material.dart';

class CoachHomeViewModel extends ChangeNotifier {
  UserAccount? user;
  CoachHomeViewModel(this.user);
  final AuthenticationService _auth = AuthenticationService();
  List<UserAccount?> clients = [];
  List<Request?> requests = [];

  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<String> refreshUserData() async {
    try {
      UserAccount updatedUser = await _auth.getCurrentUserAccountObject();
      user = updatedUser;
      notifyListeners();
      return "Successfully fetched user.";
    } catch (e) {
      return "Failed to get user.";
    }
  }

  Future<void> getClientObjectsForCoach() async {
    clients = await _auth.getClientObjectsForCoach();
    notifyListeners();
  }

  Future<void> getPendingRequestsForCoach() async {
    requests = await _auth.getPendingRequestsForCoach();
    notifyListeners();
  }

  Future<String> acceptRequest(Request request) async {
    var message = await _auth.acceptRequest(request);
    await getClientObjectsForCoach();
    await getPendingRequestsForCoach();
    notifyListeners();
    return message;
  }

  Future<String> denyRequest(Request request) async {
    final _db = FirebaseFirestore.instance;
    try {
      await _db.runTransaction((transaction) async {
        // Get the request document from the 'requests' collection
        DocumentReference requestRef =
            _db.collection('requests').doc(request.id);
        DocumentSnapshot requestSnapshot = await transaction.get(requestRef);

        if (!requestSnapshot.exists) {
          throw Exception("Request does not exist!");
        }

        // Delete the request document
        transaction.delete(requestRef);
      });

      // Refresh the coach's client objects and pending requests
      await getClientObjectsForCoach();
      await getPendingRequestsForCoach();
      notifyListeners();

      // Return a success message if the transaction completes successfully
      return "Request denied successfully.";
    } catch (e) {
      // If an exception is caught, return an error message
      return "Error occurred while denying the request: ${e.toString()}";
    }
  }

  Future<UserAccount?> getUser(String id) async {
    try {
      final user = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: id)
          .get();
      if (user.docs.isNotEmpty) {
        final userData = user.docs.first.data();
        final userModel = UserAccount.fromJson(userData);
        return userModel;
      }
    } catch (e) {
      print("Error during getting user data: $e");
    }
    return null;
  }

  Future<List<String>> getWorkouts(String clientId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(clientId)
          .get();
      if (userDoc.exists) {
        final workoutIds =
            List<String>.from(userDoc.data()?['workoutIds'] ?? []);
        return workoutIds;
      }
    } catch (e) {
      print("Error fetching workouts: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>?> getWorkout(String workoutId) async {
    try {
      final workoutDoc = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .get();
      if (workoutDoc.exists) {
        return workoutDoc.data();
      }
    } catch (e) {
      print("Error fetching workout: $e");
    }
    return null;
  }

  Future<void> addWorkoutId(WorkoutModel workoutModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(workoutModel.clientId)
          .update({
        'workoutIds': FieldValue.arrayUnion([workoutModel.id]),
      });

      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutModel.id)
          .set(workoutModel.toJson());
    } catch (e) {
      print("Error adding workout: $e");
    }
  }

  Future<String> getWorkoutCount(String id) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    final workoutIds = List<String>.from(userDoc.data()?['workoutIds'] ?? []);
    final newWorkoutName = 'Workout ${workoutIds.length + 1}';

    return newWorkoutName;
  }

  Future<void> setWeeks(String workoutId, List<int> weekList) async {
    CollectionReference weeksCollection = FirebaseFirestore.instance
        .collection("workouts")
        .doc(workoutId)
        .collection("weeks");

    for (int week in weekList) {
      for (int i = 0; i < week; i++) {
        final weekDoc = "Week${i + 1}";
        final weekModel = WeekModel(name: "Week${i + 1}", id: "Week${i + 1}");
        await weeksCollection.doc(weekDoc).set(weekModel.toJson());
      }
    }
  }

  Future<int> getWeekCount(String workoutId) async {
    try {
      final QuerySnapshot weekSnapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection("weeks")
          .get();

      // Get the number of documents in the collection
      final int count = weekSnapshot.size;

      return count;
    } catch (e) {
      print("Error getting week count: $e");
      return 0; // Return 0 if there's an error
    }
  }

  Future<void> addDayToWeek(
      String workoutId, String weekId, DayModel dayModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayModel.id)
          .set(dayModel.toJson());
    } catch (e) {
      print('Error adding day: $e');
    }
  }

  Future<List<DayModel>> getDays(String workoutId, String weekId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .get();
      return snapshot.docs.map((doc) => DayModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error fetching days: $e');
      return [];
    }
  }

  Future<List<String>> getDayNames(String workoutId, String weekId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .get();
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      print('Error fetching days: $e');
      return [];
    }
  }

  Future<void> addExerciseToDay(String workoutId, String weekId, String dayId,
      ExerciseModel exerciseModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayId)
          .collection('exercises')
          .doc(exerciseModel.id)
          .set(exerciseModel.toJson());
    } catch (e) {
      print('Error adding exercise: $e');
    }
  }

  Future<List<ExerciseModel>> getExercises(
      String workoutId, String weekId, String dayId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayId)
          .collection('exercises')
          .get();
      return snapshot.docs
          .map((doc) => ExerciseModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching exercises: $e');
      return [];
    }
  }

  Future<void> addSetToExercise(String workoutId, String weekId, String dayId,
      String exerciseId, SetModel setModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayId)
          .collection('exercises')
          .doc(exerciseId)
          .collection('sets')
          .doc(setModel.id)
          .set(setModel.toJson());
    } catch (e) {
      print('Error adding set: $e');
    }
  }

  Future<List<SetModel>> getSets(
      String workoutId, String weekId, String dayId, String exerciseId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayId)
          .collection('exercises')
          .doc(exerciseId)
          .collection('sets')
          .get();
      return snapshot.docs.map((doc) => SetModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error fetching sets: $e');
      return [];
    }
  }

  Future<int> getNumberOfWeeks(String workoutId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .get();
      return snapshot.size;
    } catch (e) {
      print('Error fetching number of weeks: $e');
      return 0;
    }
  }

  Future<List<int>> generateWeekIndices(String workoutId) async {
    try {
      final int numberOfWeeks = await getNumberOfWeeks(workoutId);
      final List<int> weekIndices =
          List<int>.generate(numberOfWeeks, (index) => index + 1);

      return weekIndices;
    } catch (e) {
      print('Error generating week indices: $e');
      return [];
    }
  }

  Future<void> updateDay(
      String workoutId, String weekId, DayModel dayModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayModel.id)
          .update(dayModel.toJson());
    } catch (e) {
      print('Error updating day: $e');
    }
  }

  Future<String?> getClientId(String workoutId) async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null && data.containsKey('clientId')) {
          return data['clientId'] as String?;
        } else {
          print('clientId not found in document.');
          return null;
        }
      } else {
        print('Document does not exist.');
        return null;
      }
    } catch (e) {
      print('Error fetching clientId: $e');
      return null;
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      // Fetch the clientId associated with this workoutId
      String? clientId = await getClientId(workoutId);

      if (clientId != null) {
        // Remove the workoutId from the user's workoutIds list
        await FirebaseFirestore.instance
            .collection('users')
            .doc(clientId)
            .update({
          'workoutIds': FieldValue.arrayRemove([workoutId]),
        });

        // Recursively delete all sub-collections and documents
        await _deleteWorkoutSubCollections(workoutId);

        // Delete the workout document
        await FirebaseFirestore.instance
            .collection('workouts')
            .doc(workoutId)
            .delete();
      }

      notifyListeners();
    } catch (e) {
      print('Error deleting workouts: $e');
    }
  }

  Future<void> _deleteWorkoutSubCollections(String workoutId) async {
    try {
      final weeksSnapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .get();

      for (var weekDoc in weeksSnapshot.docs) {
        final daysSnapshot = await weekDoc.reference.collection('days').get();

        for (var dayDoc in daysSnapshot.docs) {
          final exercisesSnapshot =
              await dayDoc.reference.collection('exercises').get();

          for (var exerciseDoc in exercisesSnapshot.docs) {
            final setsSnapshot =
                await exerciseDoc.reference.collection('sets').get();

            for (var setDoc in setsSnapshot.docs) {
              await setDoc.reference.delete(); // Delete each set document
            }

            await exerciseDoc.reference
                .delete(); // Delete each exercise document
          }

          await dayDoc.reference.delete(); // Delete each day document
        }

        await weekDoc.reference.delete(); // Delete each week document
      }
    } catch (e) {
      print('Error deleting workout sub-collections: $e');
    }
  }

  Future<void> deleteDay(String workoutId, String weekId, String dayId) async {
    try {
      // Reference to the specific day document
      final dayRef = FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayId);

      // Delete the document
      await dayRef.delete();

      // Delete all sub-collections and documents
      await _deleteDaySubCollections(workoutId, weekId, dayId);

      print(
          'Day $dayId deleted successfully from $weekId in workout $workoutId.');
    } catch (e) {
      print('Failed to delete day: $e');
    }
  }

  Future<void> _deleteDaySubCollections(
      String workoutId, String weekId, String dayId) async {
    try {
      final exercisesSnapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayId)
          .collection('exercises')
          .get();

      for (var exerciseDoc in exercisesSnapshot.docs) {
        final setsSnapshot =
            await exerciseDoc.reference.collection('sets').get();

        for (var setDoc in setsSnapshot.docs) {
          await setDoc.reference.delete(); // Delete each set document
        }

        await exerciseDoc.reference.delete(); // Delete each exercise document
      }
    } catch (e) {
      print('Error deleting day sub-collections: $e');
    }
  }

  Future<void> deleteSetFromExercise(String workoutId, String weekId,
      String dayId, String exerciseId, String setId) async {
    try {
      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayId)
          .collection('exercises')
          .doc(exerciseId)
          .collection('sets')
          .doc(setId)
          .delete();
    } catch (e) {
      print('Error deleting set: $e');
    }
  }

  Future<void> setDayCompletition(
      String workoutId, String weekId, DayModel dayModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('workouts')
          .doc(workoutId)
          .collection('weeks')
          .doc(weekId)
          .collection('days')
          .doc(dayModel.id)
          .update({'completed': true} );
    } catch (e) {
      print('Error updating day: $e');
    }
  }
}
