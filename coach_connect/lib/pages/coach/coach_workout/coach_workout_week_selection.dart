import 'package:coach_connect/pages/coach/coach_workout/coach_workout_days_planning.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:flutter/material.dart';

class CoachWorkoutWeekSelectionPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;
  final String workoutId;

  const CoachWorkoutWeekSelectionPage({
    Key? key,
    required this.viewModel,
    required this.workoutId,
  }) : super(key: key);

  @override
  _CoachWorkoutWeekSelectionPageState createState() => _CoachWorkoutWeekSelectionPageState();
}

class _CoachWorkoutWeekSelectionPageState extends State<CoachWorkoutWeekSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Week Selection',
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: WeekSelector(
        viewModel: widget.viewModel,
        workoutId: widget.workoutId,
      ),
    );
  }
}

class WeekSelector extends StatefulWidget {
  final CoachHomeViewModel viewModel;
  final String workoutId;

  const WeekSelector({
    Key? key,
    required this.viewModel,
    required this.workoutId,
  }) : super(key: key);

  @override
  _WeekSelectorState createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  List<int> selectedWeeks = [1]; // Default to 1 week selected

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 20.0, left: 8.0),
          child: Text(
            'How many weeks?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<int>(
            value: selectedWeeks.isNotEmpty ? selectedWeeks[0] : 1,
            dropdownColor: const Color.fromARGB(255, 56, 80, 88),
            style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
            onChanged: (int? value) {
              setState(() {
                selectedWeeks.clear();
                selectedWeeks.add(value!);
              });
            },
            items: List.generate(
              10,
              (index) => DropdownMenuItem<int>(
                value: index + 1,
                child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () async {
                // Navigate to the next page with selectedWeeks
                await widget.viewModel.setWeeks(widget.workoutId, selectedWeeks);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectedWeeksPage(
                      viewModel: widget.viewModel,
                      workoutId: widget.workoutId,
                      selectedWeeks: selectedWeeks,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                backgroundColor: const Color.fromARGB(255, 56, 80, 88),
              ),
              child: const Text('Next'),
            ),
          ),
        ),
      ],
    );
  }
}
