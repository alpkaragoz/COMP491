import 'package:flutter/material.dart';
import 'package:coach_connect/models/set.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';

class CoachWorkoutPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;
  final String workoutId;
  final String weekId;
  final String dayId;
  final String exerciseId; 
  final String exerciseName; // Add exerciseName parameter

  const CoachWorkoutPage({
    Key? key,
    required this.viewModel,
    required this.workoutId,
    required this.weekId,
    required this.dayId,
    required this.exerciseId, 
    required this.exerciseName, // Add exerciseName parameter
  }) : super(key: key);

  @override
  _CoachWorkoutPageState createState() => _CoachWorkoutPageState();
}

class _CoachWorkoutPageState extends State<CoachWorkoutPage> {
  List<SetModel> sets = [];

  TextEditingController rpeController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController kgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSets();
  }

  Future<void> fetchSets() async {
    final fetchedSets = await widget.viewModel.getSets(
      widget.workoutId,
      widget.weekId,
      widget.dayId,
      widget.exerciseId,
    );
    setState(() {
      sets = fetchedSets;
    });
  }

  void addSet() {
    final newSet = SetModel(id: 'set${sets.length + 1}');
    setState(() {
      sets.add(newSet);
    });
  }

  void saveSet(int index) async {
  final updatedSet = sets[index].copyWith(
    rpe: rpeController.text,
    reps: repsController.text,
    kg: kgController.text,
  );

  await widget.viewModel.addSetToExercise(
    widget.workoutId,
    widget.weekId,
    widget.dayId,
    widget.exerciseId,
    updatedSet,
  );

  setState(() {
    sets[index] = updatedSet;
  });

  Navigator.pop(context); // Close the bottom sheet only
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.exerciseName), // Use exerciseName as the title
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: sets.length,
            itemBuilder: (context, index) {
              final set = sets[index];
              return ListTile(
                title: Text('Set ${index + 1}'),
                subtitle: Text('RPE: ${set.rpe}, Reps: ${set.reps}, Kg: ${set.kg}'),
                onTap: () {
                  rpeController.text = set.rpe ?? '';
                  repsController.text = set.reps ?? '';
                  kgController.text = set.kg ?? '';

                  FocusScope.of(context).requestFocus(FocusNode());

                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true, // Ensure bottom sheet is scrollable
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: rpeController,
                                decoration: InputDecoration(labelText: 'RPE'),
                                keyboardType: TextInputType.number,
                              ),
                              TextField(
                                controller: repsController,
                                decoration: InputDecoration(labelText: 'Reps'),
                                keyboardType: TextInputType.number,
                              ),
                              TextField(
                                controller: kgController,
                                decoration: InputDecoration(labelText: 'Kg'),
                                keyboardType: TextInputType.number,
                              ),
                              ElevatedButton(
                                onPressed: () => saveSet(index),
                                child: Text('Save Set'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: addSet,
          child: Text('Add Set'),
        ),
      ],
    ),
  );
}

}