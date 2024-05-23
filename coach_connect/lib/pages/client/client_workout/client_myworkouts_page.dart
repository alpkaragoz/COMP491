import 'package:coach_connect/pages/client/client_workout/client_myworkouts_days_page.dart';
import 'package:coach_connect/pages/client/client_workout/client_myworkouts_weeks_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientMyWorkoutsPage extends StatefulWidget {
  final ClientHomeViewModel viewModel;

  const ClientMyWorkoutsPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  _ClientMyWorkoutsPageState createState() => _ClientMyWorkoutsPageState();
}

class _ClientMyWorkoutsPageState extends State<ClientMyWorkoutsPage> {
  List<String> workouts = [];
  bool hasWorkouts = false;

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    try {
      final fetchedWorkouts = await widget.viewModel.getWorkouts();
      setState(() {
        workouts = fetchedWorkouts;
        hasWorkouts = workouts.isNotEmpty;
      });
    } catch (e) {
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
          hasWorkouts
              ? Expanded(
                  child: ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workoutId = workouts[index];
                      return FutureBuilder(
                        future: widget.viewModel.getWorkout(workoutId),
                        builder: (context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                          final workoutName = snapshot.data?['name'] ?? 'Unnamed Workout';
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.black, width: 1.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  navigateToClientMyWorkoutsWeeksPage(context, workoutId);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 48)),
                                ),
                                child: snapshot.connectionState != ConnectionState.waiting
                                    ? Text(
                                        workoutName,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Center(
                  child: Text('No workouts currently'),
                ),
        ],
      ),
    );
  }

  void navigateToClientMyWorkoutsWeeksPage(BuildContext context, String workoutId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientMyWorkoutsWeeksPage(viewModel: widget.viewModel, workoutId: workoutId)
      ),
    );
  }
}
