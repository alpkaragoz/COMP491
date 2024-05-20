import 'package:coach_connect/models/day.dart';
import 'package:coach_connect/models/exercise.dart';
import 'package:coach_connect/pages/coach/coach_workout/coach_workout_page.dart';
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
  List<List<ExerciseModel>> enteredExercisesByDay =
      List.generate(1, (index) => []);

  @override
  void initState() {
    super.initState();
    fetchDaysForWeek(selectedWeek);
  }

  Future<void> fetchDaysForWeek(int week) async {
    final weekId = 'Week$week';
    final days = await widget.viewModel.getDays(widget.workoutId, weekId);

    List<List<ExerciseModel>> exercises = [];
    for (var day in days) {
      final dayExercises = await widget.viewModel
          .getExercises(widget.workoutId, weekId, day.id!);
      exercises.add(dayExercises);
    }

    setState(() {
      enteredExercisesByDay = exercises;
    });
  }

  void addDay() async {
    final dayModel = DayModel(
        name: 'Day${enteredExercisesByDay.length + 1}',
        id: 'day${enteredExercisesByDay.length + 1}');
    await widget.viewModel
        .addDayToWeek(widget.workoutId, 'Week$selectedWeek', dayModel);

    setState(() {
      enteredExercisesByDay.add([]);
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
                            Text(
                              'Day ${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                enteredExercisesByDay[index].length,
                                (exerciseIndex) {
                                  final exercise = enteredExercisesByDay[index]
                                      [exerciseIndex];
                                  final exerciseNumber = exerciseIndex + 1;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      '$exerciseNumber. ${exercise.name}',
                                    ),
                                  );
                                },
                              ),
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
                                                onPressed: () async {
                                                  final exerciseName =
                                                      exerciseController.text;
                                                  if (exerciseName.isNotEmpty) {
                                                    final dayId =
                                                        'day${index + 1}';
                                                    final weekId =
                                                        'Week$selectedWeek';
                                                    final existingExercises =
                                                        await widget.viewModel
                                                            .getExercises(
                                                                widget
                                                                    .workoutId,
                                                                weekId,
                                                                dayId);

                                                    final nextExerciseId =
                                                        'exercise${existingExercises.length + 1}';

                                                    final exerciseModel =
                                                        ExerciseModel(
                                                      id: nextExerciseId,
                                                      name: exerciseName,
                                                    );

                                                    await widget.viewModel
                                                        .addExerciseToDay(
                                                      widget.workoutId,
                                                      weekId,
                                                      dayId,
                                                      exerciseModel,
                                                    );

                                                    setState(() {
                                                      enteredExercisesByDay[
                                                              index]
                                                          .add(exerciseModel);
                                                      exerciseController
                                                          .clear();
                                                    });

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CoachWorkoutPage(
                                                          viewModel:
                                                              widget.viewModel,
                                                          workoutId:
                                                              widget.workoutId,
                                                          weekId: weekId,
                                                          dayId: dayId,
                                                          exerciseId:
                                                              exerciseModel.id
                                                                  .toString(),
                                                          exerciseName:
                                                              exerciseName, // Pass exerciseName
                                                        ),
                                                      ),
                                                    );
                                                  }
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
