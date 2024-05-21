import 'package:flutter/material.dart';
import 'package:coach_connect/models/set.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:flutter/services.dart';

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
      if (sets.isEmpty) {
        addSet();
      }
    });
  }

  void addSet() {
    final newSet = SetModel(id: 'set${sets.length + 1}');
    setState(() {
      sets.add(newSet);
    });
  }

  void saveSet(int index) async {
    if (rpeController.text.isEmpty ||
        repsController.text.isEmpty ||
        kgController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter values for RPE, Reps, and Kg.'),
        ),
      );
      return;
    }

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

  void saveExercise() {
    bool allSetsValid = true;

    for (var set in sets) {
      if (set.rpe == null || set.rpe!.isEmpty ||
          set.reps == null || set.reps!.isEmpty ||
          set.kg == null || set.kg!.isEmpty) {
        allSetsValid = false;
        break;
      }
    }

    if (!allSetsValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please ensure all sets have values for RPE, Reps, and Kg.'),
        ),
      );
      return;
    }

    // Implement save exercise logic here
    Navigator.pop(context);
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
                  subtitle:
                      Text('RPE: ${set.rpe}, Reps: ${set.reps}, Kg: ${set.kg}'),
                  onTap: () {
                    rpeController.text = set.rpe ?? '';
                    repsController.text = set.reps ?? '';
                    kgController.text = set.kg ?? '';

                    FocusScope.of(context).requestFocus(FocusNode());

                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled:
                          true, // Ensure bottom sheet is scrollable
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ], // Allow only numbers
                                ),
                                TextField(
                                  controller: repsController,
                                  decoration:
                                      InputDecoration(labelText: 'Reps'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ], // Allow only numbers
                                ),
                                TextField(
                                  controller: kgController,
                                  decoration: InputDecoration(labelText: 'Kg'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'))
                                  ], // Allow only numbers
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
          Padding(
            padding:
                const EdgeInsets.all(8.0), // Add padding for better spacing
            child: ElevatedButton(
              onPressed: addSet,
              child: Text('Add Set'),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.all(8.0), // Add padding for better spacing
            child: ElevatedButton(
              onPressed: saveExercise,
              child: Text('Save Exercise'),
            ),
          ),
        ],
      ),
    );
  }
}
