import 'package:coach_connect/models/day.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';

class SelectedWeeksPage extends StatefulWidget {
  final List<int> selectedWeeks;
  final CoachHomeViewModel viewModel;
  final String workoutId;

  const SelectedWeeksPage({
    Key? key,
    required this.viewModel,
    required this.selectedWeeks,
    required this.workoutId,
  }) : super(key: key);

  @override
  _SelectedWeeksPageState createState() => _SelectedWeeksPageState();
}

class _SelectedWeeksPageState extends State<SelectedWeeksPage> {
  int selectedWeek = 1;
  TextEditingController exerciseController = TextEditingController();
  List<List<String>> enteredExercisesByDay = [[]];

  @override
  void initState() {
    super.initState();
    fetchDaysForWeek(selectedWeek);
  }

  Future<void> fetchDaysForWeek(int week) async {
    final weekId = 'Week$week';
    final days = await widget.viewModel.getDays(widget.workoutId, weekId);
    setState(() {
      enteredExercisesByDay = days.map((day) => [day.name!]).toList();
    });
  }

  void addDay() {
    setState(() {
      enteredExercisesByDay.add([]);
    });
    final dayModel = DayModel(name: 'Day${enteredExercisesByDay.length}', id: 'day${enteredExercisesByDay.length}');
    widget.viewModel.addDayToWeek(widget.workoutId, 'Week$selectedWeek', dayModel);
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
                      fetchDaysForWeek(week);
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
                          color: Colors.grey[200],
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
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: 16),
                                              TextField(
                                                controller: exerciseController,
                                                decoration: InputDecoration(
                                                  hintText: 'Enter exercise',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    enteredExercisesByDay[index]
                                                        .add(exerciseController.text);
                                                    exerciseController.clear();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Add'),
                                              ),
                                            ],
                                          ),
                                        ),
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