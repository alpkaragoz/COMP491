import 'package:coach_connect/pages/client/client_workout/client_myworkouts_days_page.dart';
import 'package:coach_connect/pages/client/client_workout/client_workout_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientMyWorkoutsWeeksPage extends StatelessWidget {
  final ClientHomeViewModel viewModel;
  final String workoutId;

  const ClientMyWorkoutsWeeksPage({Key? key, required this.viewModel, required this.workoutId})
      : super(key: key);

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
                  onPressed: () {
                    navigateToClientMyWorkoutsDaysPage(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 48)),
                  ),
                  child: Text(
                    'Week 1',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          // Add other widgets below the button if needed
        ],
      ),
    );
  }

  void navigateToClientMyWorkoutsDaysPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientMyWorkoutsDaysPage(viewModel: viewModel, workoutId: workoutId)
      ),
    );
  }
}
