import 'package:coach_connect/models/user_account.dart';
import 'package:coach_connect/pages/coach/coach_workout/coach_workout_week_selection.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:flutter/material.dart';

class CoachWorkoutIdsPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;
  final String clientId;

  const CoachWorkoutIdsPage({Key? key, required this.viewModel, required this.clientId})
      : super(key: key);

  @override
  _CoachWorkoutIdsPageState createState() => _CoachWorkoutIdsPageState();
}



class _CoachWorkoutIdsPageState extends State<CoachWorkoutIdsPage> {
  List<String> workouts = [];
  bool hasWorkouts = false;


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
                      return GestureDetector(
                        onTap: () {
                          navigateToClientMyWorkoutsDailyPage(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black, // Light grey color
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Workout ${index + 1}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                    workouts[index].length, (exerciseIndex) {
                                  final exerciseNumber = exerciseIndex + 1;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                        '$exerciseNumber. ${workouts[index][exerciseIndex]}'),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
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
                  onPressed: () {
                    addDay(widget.viewModel, widget.clientId);
                    navigateToClientMyWorkoutsDailyPage(context);
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

  void navigateToClientMyWorkoutsDailyPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CoachWorkoutWeekSelectionPage(viewModel: widget.viewModel)),
    );
  }

}
Future<void> addDay(CoachHomeViewModel viewModel, String clientId) async {
    await CoachHomeViewModel(viewModel.user).addWorkoutId(clientId);
  }