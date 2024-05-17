import 'package:coach_connect/pages/coach/coach_workout/coach_workout_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';

class SelectedWeeksPage extends StatefulWidget {
  final List<int> selectedWeeks;
  final CoachHomeViewModel viewModel;
  final String workoutId;

  const SelectedWeeksPage({Key? key,required this.viewModel, required this.selectedWeeks, required this.workoutId})
      : super(key: key);

  @override
  _SelectedWeeksPageState createState() => _SelectedWeeksPageState();
}

class _SelectedWeeksPageState extends State<SelectedWeeksPage> {
  int selectedWeek = 1; // Initialize selectedWeek to 1
  int selectedDay = 1; // Initialize selectedWeek to 1
  TextEditingController exerciseController =
      TextEditingController(); // Controller for the exercise TextField
  List<List<String>> enteredExercisesByDay = [
    []
  ]; // Track the entered exercises by day

  void addDay() {
    setState(() {
      enteredExercisesByDay
          .add([]); // Add a new day with an empty list of exercises
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Program'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.selectedWeeks.last, (index) {
                final week = index + 1;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedWeek = week;
                      });
                    },
                    child: Text('Week $week'),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: enteredExercisesByDay.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Light grey color
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Day ${index + 1}'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  enteredExercisesByDay[index].length,
                                  (exerciseIndex) {
                                final exerciseNumber = exerciseIndex + 1;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Text(
                                      '$exerciseNumber. ${enteredExercisesByDay[index][exerciseIndex]}'),
                                );
                              }),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      height: 200,
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller:
                                                exerciseController, // Use the controller
                                            decoration: InputDecoration(
                                              hintText: 'Enter exercise',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the bottom sheet
                                  Navigator.push( // Navigate to CoachWorkoutPage
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CoachWorkoutPage(viewModel: widget.viewModel)
                                    ),
                                  );
                                },
                                child: Text('Add'),
                              ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text('Add Exercise'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: addDay,
                    child: Text('Add Day'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
