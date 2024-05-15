import 'package:coach_connect/pages/client/client_workout/client_myworkouts_daily_page.dart';
import 'package:coach_connect/pages/coach/coach_workout/coach_workout_days_planning.dart';
import 'package:coach_connect/pages/coach/coach_workout/coach_workout_page.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class CoachWorkoutWeekSelectionPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;

  const CoachWorkoutWeekSelectionPage({Key? key, required this.viewModel})
      : super(key: key);

  @override
  _CoachWorkoutWeekSelectionPageState createState() =>
      _CoachWorkoutWeekSelectionPageState();
}

class _CoachWorkoutWeekSelectionPageState
    extends State<CoachWorkoutWeekSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week Selection'),
      ),
      body: WeekSelector(viewModel: widget.viewModel),
    );
  }
}

class WeekSelector extends StatefulWidget {
  final CoachHomeViewModel viewModel;

  const WeekSelector({Key? key, required this.viewModel}) : super(key: key);

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
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 8.0),
          child: Text(
            'How many weeks?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: DropdownButton<int>(
            value: selectedWeeks.isNotEmpty ? selectedWeeks[0] : 1,
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
                child: Text('${index + 1}'),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the next page with selectedWeeks
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SelectedWeeksPage(selectedWeeks: selectedWeeks)),
                );
              },
              child: Text('Next'),
            ),
          ),
        ),
      ],
    );
  }
}
