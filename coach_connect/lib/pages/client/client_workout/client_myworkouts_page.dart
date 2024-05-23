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
        title: const Text(
          'My Workouts',
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
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
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Color.fromARGB(255, 56, 80, 88), width: 1.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  navigateToClientMyWorkoutsWeeksPage(context, workoutId);
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
                          );
                        },
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text('No workouts currently', style: TextStyle(color: Colors.white)),
                ),
        ],
      ),
    );
  }

  void navigateToClientMyWorkoutsWeeksPage(BuildContext context, String workoutId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientMyWorkoutsWeeksPage(viewModel: widget.viewModel, workoutId: workoutId),
      ),
    );
  }
}
