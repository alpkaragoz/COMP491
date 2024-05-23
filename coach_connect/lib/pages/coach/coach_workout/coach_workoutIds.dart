import 'package:coach_connect/models/workout.dart';
import 'package:coach_connect/pages/coach/coach_workout/coach_workout_days_planning.dart';
import 'package:coach_connect/pages/coach/coach_workout/coach_workout_week_selection.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CoachWorkoutIdsPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;
  final String clientId;

  const CoachWorkoutIdsPage({
    Key? key,
    required this.viewModel,
    required this.clientId,
  }) : super(key: key);

  @override
  _CoachWorkoutIdsPageState createState() => _CoachWorkoutIdsPageState();
}

class _CoachWorkoutIdsPageState extends State<CoachWorkoutIdsPage> {
  List<String> workouts = [];
  bool hasWorkouts = false;

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    try {
      final fetchedWorkouts = await widget.viewModel.getWorkouts(widget.clientId);
      setState(() {
        workouts = fetchedWorkouts;
        hasWorkouts = workouts.isNotEmpty;
      });
    } catch (e) {
      // Handle errors
      print('Error fetching workouts: $e');
      setState(() {
        workouts = [];
        hasWorkouts = false;
      });
    }
  }

  var count = 0;
  var workout = "Workout";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts', style: TextStyle(color: Color.fromARGB(255, 226, 182, 167))),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 226, 182, 167)),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: hasWorkouts
                ? ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workoutId = workouts[index];
                      return FutureBuilder(
                        future: widget.viewModel.getWorkout(workoutId),
                        builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                          final workoutName = snapshot.data?['name'] ?? 'Unnamed Workout';
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color.fromARGB(255, 56, 80, 88), width: 1.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        navigateToClientMyWorkoutsDailyPage(context, workoutId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                                        minimumSize: const Size(double.infinity, 48),
                                      ),
                                      child: snapshot.connectionState != ConnectionState.waiting
                                          ? Text(
                                              workoutName,
                                              style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                                            )
                                          : const CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 226, 182, 167)),
                                            ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, workoutId);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text('No workouts currently', style: TextStyle(color: Colors.white)),
                  ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color.fromARGB(255, 56, 80, 88), width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await addWorkout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'Add Workout',
                    style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addWorkout() async {
    try {
      final name = await widget.viewModel.getWorkoutCount(widget.clientId);
      await widget.viewModel.addWorkoutId(WorkoutModel(
          id: Uuid().v4(),
          clientId: widget.clientId,
          coachId: widget.viewModel.user!.id,
          name: name));
      await fetchWorkouts();
    } catch (e) {
      // Handle errors
      print('Error adding workout: $e');
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      await widget.viewModel.deleteWorkout(workoutId);
      await fetchWorkouts();
    } catch (e) {
      // Handle errors
      print('Error deleting workout: $e');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String workoutId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this workout?', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 56, 80, 88),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 226, 182, 167))),
          ),
          TextButton(
            onPressed: () {
              deleteWorkout(workoutId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void navigateToClientMyWorkoutsDailyPage(BuildContext context, workoutId) async {
    final weekCount = await widget.viewModel.getWeekCount(workoutId);
    if (weekCount == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CoachWorkoutWeekSelectionPage(
            viewModel: widget.viewModel,
            workoutId: workoutId,
          ),
        ),
      );
    } else {
      final weekSelection = await widget.viewModel.generateWeekIndices(workoutId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectedWeeksPage(
            viewModel: widget.viewModel,
            selectedWeeks: weekSelection,
            workoutId: workoutId,
          ),
        ),
      );
    }
  }
}
