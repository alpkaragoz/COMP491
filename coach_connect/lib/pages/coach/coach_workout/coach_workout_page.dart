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
  final String exerciseName;

  const CoachWorkoutPage({
    Key? key,
    required this.viewModel,
    required this.workoutId,
    required this.weekId,
    required this.dayId,
    required this.exerciseId,
    required this.exerciseName,
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

  void deleteSet(int index) async {
    final setToDelete = sets[index];
    if (setToDelete.id != null) {
      await widget.viewModel.deleteSetFromExercise(
        widget.workoutId,
        widget.weekId,
        widget.dayId,
        widget.exerciseId,
        setToDelete.id!,
      );

      setState(() {
        sets.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete set: Invalid set ID.'),
        ),
      );
    }
  }

  void saveSet(int index) async {
    if (rpeController.text.isEmpty ||
        repsController.text.isEmpty ||
        kgController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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

    Navigator.pop(context);
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
        const SnackBar(
          content: Text('Please ensure all sets have values for RPE, Reps, and Kg.'),
        ),
      );
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exerciseName, style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167))),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sets.length,
              itemBuilder: (context, index) {
                final set = sets[index];
                return ListTile(
                  title: Text('Set ${index + 1}', style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167))),
                  subtitle: Text(
                    'RPE: ${set.rpe}, Reps: ${set.reps}, Kg: ${set.kg}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteSet(index),
                  ),
                  onTap: () {
                    rpeController.text = set.rpe ?? '';
                    repsController.text = set.reps ?? '';
                    kgController.text = set.kg ?? '';

                    FocusScope.of(context).requestFocus(FocusNode());

                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: const Color.fromARGB(255, 56, 80, 88),
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
                                  decoration: const InputDecoration(
                                    labelText: 'RPE',
                                    labelStyle: TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: repsController,
                                  decoration: const InputDecoration(
                                    labelText: 'Reps',
                                    labelStyle: TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: kgController,
                                  decoration: const InputDecoration(
                                    labelText: 'Kg',
                                    labelStyle: TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => saveSet(index),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                                    backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                                  ),
                                  child: const Text('Save Set'),
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
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: addSet,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                backgroundColor: const Color.fromARGB(255, 56, 80, 88),
              ),
              child: const Text('Add Set'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: saveExercise,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                backgroundColor: const Color.fromARGB(255, 56, 80, 88),
              ),
              child: const Text('Save Exercise'),
            ),
          ),
        ],
      ),
    );
  }
}
