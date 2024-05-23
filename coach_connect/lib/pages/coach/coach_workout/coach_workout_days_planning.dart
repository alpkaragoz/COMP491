import 'package:coach_connect/models/day.dart';
import 'package:coach_connect/models/exercise.dart';
import 'package:coach_connect/models/set.dart';
import 'package:coach_connect/pages/coach/coach_workout/coach_workout_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:uuid/uuid.dart';

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
  TextEditingController dayNameController = TextEditingController();
  List<List<ExerciseModel>> enteredExercisesByDay = List.generate(1, (index) => []);
  List<String> dayNames = [];
  Map<String, List<SetModel>> setsByExercise = {};
  List<String> dayIds = []; // List to store day IDs

  @override
  void initState() {
    super.initState();
    fetchDaysForWeek(selectedWeek);
  }

  Future<void> fetchDaysForWeek(int week) async {
    final weekId = 'Week$week';
    final days = await widget.viewModel.getDays(widget.workoutId, weekId);

    // Sort days by ID to maintain the order they were added
    days.sort((a, b) => a.id!.compareTo(b.id!));

    List<List<ExerciseModel>> exercises = [];
    Map<String, List<SetModel>> fetchedSetsByExercise = {};
    List<String> fetchedDayIds = [];

    for (var day in days) {
      final dayExercises = await widget.viewModel.getExercises(widget.workoutId, weekId, day.id!);
      exercises.add(dayExercises);
      fetchedDayIds.add(day.id!);

      for (var exercise in dayExercises) {
        final sets = await widget.viewModel.getSets(widget.workoutId, weekId, day.id!, exercise.id!);
        fetchedSetsByExercise[exercise.id!] = sets;
      }
    }

    setState(() {
      enteredExercisesByDay = exercises;
      setsByExercise = fetchedSetsByExercise;
      dayIds = fetchedDayIds;
      fetchDayNames(weekId);
    });
}

  Future<void> fetchDayNames(String weekId) async {
    final names = await widget.viewModel.getDayNames(widget.workoutId, weekId);
    setState(() {
      dayNames = names;
    });
  }

  void addDay() async {
    final uuid = Uuid();
    final newDayId = uuid.v4(); // Generate a unique ID for the new day
    final dayModel = DayModel(
      name: 'Day ${enteredExercisesByDay.length + 1}',
      id: newDayId,
    );
    await widget.viewModel.addDayToWeek(widget.workoutId, 'Week$selectedWeek', dayModel);

    setState(() {
      enteredExercisesByDay.add([]);
      dayNames.add(dayModel.name);
      dayIds.add(newDayId); // Add the new day ID to the list
    });
  }

  void updateDayName(int index, String newName) async {
    final dayId = dayIds[index]; // Use the day ID from the list
    final weekId = 'Week$selectedWeek';

    final dayModel = DayModel(
      name: newName,
      id: dayId,
    );

    await widget.viewModel.updateDay(widget.workoutId, weekId, dayModel);

    setState(() {
      dayNames[index] = newName;
    });
  }

  Future<void> deleteDay(int index) async {
    final dayId = dayIds[index]; // Use the day ID from the list
    final weekId = 'Week$selectedWeek';

    await widget.viewModel.deleteDay(widget.workoutId, weekId, dayId);

    setState(() {
      enteredExercisesByDay.removeAt(index);
      dayNames.removeAt(index);
      dayIds.removeAt(index); // Remove the day ID from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Make a Program',
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
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
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                      backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                    ),
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
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 56, 80, 88),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dayNames.length > index ? dayNames[index] : 'Day ${index + 1}',

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Color.fromARGB(255, 226, 182, 167),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Color.fromARGB(255, 226, 182, 167)),
                                  onPressed: () {
                                    dayNameController.text = dayNames.isNotEmpty ? dayNames[index] : 'Day ${index + 1}';
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Edit Day Name',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                                          content: TextField(
                                            controller: dayNameController,
                                            style: const TextStyle(color: Colors.white),
                                            decoration: const InputDecoration(
                                              hintText: 'Enter new day name',
                                              hintStyle: TextStyle(color: Colors.white54),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Save', style: TextStyle(color: Colors.white)),
                                              onPressed: () {
                                                updateDayName(index, dayNameController.text);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Delete Day',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                                          content: const Text(
                                            'Are you sure you want to delete this day?',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                              onPressed: () {
                                                deleteDay(index);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: enteredExercisesByDay[index].length,
                              itemBuilder: (context, exerciseIndex) {
                                final exercise = enteredExercisesByDay[index][exerciseIndex];
                                final sets = setsByExercise[exercise.id!] ?? [];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CoachWorkoutPage(
      viewModel: widget.viewModel,
      workoutId: widget.workoutId,
      weekId: 'Week$selectedWeek',
      dayId: dayIds[index],
      exerciseId: exercise.id!,
      exerciseName: exercise.name ?? 'Unnamed Exercise',
    ),
  ),
);

                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 28, 40, 44),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      exercise.name ?? 'Unnamed Exercise', // Ensure non-nullable String
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8.0),
                            TextField(
  controller: exerciseController,
  style: const TextStyle(color: Colors.white),
  decoration: InputDecoration(
    hintText: 'Enter exercise name',
    hintStyle: const TextStyle(color: Colors.white54),
    suffixIcon: IconButton(
      icon: const Icon(Icons.add, color: Colors.white),
      onPressed: () async {
        if (exerciseController.text.isNotEmpty) {
          final uuid = Uuid();
          final newExercise = ExerciseModel(
            id: uuid.v4(),
            name: exerciseController.text,
          );
          final weekId = 'Week$selectedWeek';
          final dayId = dayIds[index]; // Use the day ID from the list

          await widget.viewModel.addExerciseToDay(widget.workoutId, weekId, dayId, newExercise);

          setState(() {
            enteredExercisesByDay[index].add(newExercise);
            exerciseController.clear();
          });
        }
      },
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
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
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                      backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                    ),
                    child: const Text('Add Day'),
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
