import 'package:coach_connect/pages/coach/coach_workout/coach_workout_week_selection.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:flutter/material.dart';

class CoachWorkoutIdsPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;
  final String clientId;

  const CoachWorkoutIdsPage(
      {Key? key, required this.viewModel, required this.clientId})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
      ),
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
                        builder: (context,
                            AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                          final workoutName =
                              snapshot.data?['name'] ?? 'Unnamed Workout';
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (workoutId != null) {
                                    navigateToClientMyWorkoutsDailyPage(
                                        context, workoutId);
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(double.infinity, 48)),
                                ),
                                child: snapshot.connectionState !=
                                        ConnectionState.waiting
                                    ? Text(
                                        workoutName,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Center(
                    child: Text('No workouts currently'),
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black, width: 1.0),
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
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 48)),
                  ),
                  child: Text(
                    'Add Workout',
                    style: TextStyle(color: Colors.white),
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
      await widget.viewModel.addWorkoutId(widget.clientId);
      await fetchWorkouts();
    } catch (e) {
      // Handle errors
      print('Error adding workout: $e');
    }
  }

  void navigateToClientMyWorkoutsDailyPage(
      BuildContext context, String workoutId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoachWorkoutWeekSelectionPage(
          viewModel: widget.viewModel,
          workoutId: workoutId,
        ),
      ),
    );
  }
}
