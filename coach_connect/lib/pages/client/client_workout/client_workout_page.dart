import 'package:coach_connect/pages/client/client_workout/client_interactive_workout_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/models/exercise.dart';
import 'package:coach_connect/models/set.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientWorkoutPage extends StatefulWidget {
  final ClientHomeViewModel viewModel;
  final String workoutId;
  final String weekId;
  final String dayId;
  final VoidCallback onWorkoutComplete; // Add this line

  const ClientWorkoutPage({
    Key? key,
    required this.viewModel,
    required this.workoutId,
    required this.weekId,
    required this.dayId,
    required this.onWorkoutComplete, // Add this line
  }) : super(key: key);

  @override
  _ClientWorkoutPageState createState() => _ClientWorkoutPageState();
}

class _ClientWorkoutPageState extends State<ClientWorkoutPage> {
  bool _isLoading = true;
  List<ExerciseModel> _exercises = [];
  Map<String, List<SetModel>> _exerciseSets = {};

  @override
  void initState() {
    super.initState();
    fetchExercisesAndSets();
  }

  Future<void> fetchExercisesAndSets() async {
    try {
      final exercises = await widget.viewModel.getExercises(widget.workoutId, widget.weekId, widget.dayId);
      final exerciseSets = <String, List<SetModel>>{};

      for (var exercise in exercises) {
        final sets = await widget.viewModel.getSets(widget.workoutId, widget.weekId, widget.dayId, exercise.id!);
        exerciseSets[exercise.id!] = sets;
      }

      setState(() {
        _exercises = exercises;
        _exerciseSets = exerciseSets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching exercises and sets')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercises',
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          color: Color.fromARGB(255, 56, 80, 88),
                          thickness: 1.0,
                        ),
                      ),
                      ..._exercises.map((exercise) {
                        return _buildExerciseItem(exercise);
                      }).toList(),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientInteractiveWorkoutPage(
                              viewModel: widget.viewModel,
                              workoutId: widget.workoutId,
                              weekId: widget.weekId,
                              dayId: widget.dayId,
                              onWorkoutComplete: widget.onWorkoutComplete, // Pass the callback
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                      ),
                      child: const Text(
                        'Start Workout',
                        style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildExerciseItem(ExerciseModel exercise) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            _buildDayButton(exercise.name ?? 'Unknown Exercise',
                const Color.fromARGB(255, 56, 80, 88), isExpanded, () {
              setState(() {
                isExpanded = !isExpanded;
              });
            }),
            if (isExpanded)
              ...?_exerciseSets[exercise.id]?.map((set) {
                return _buildExpandableContent(set);
              }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildDayButton(
      String day, Color buttonColor, bool isExpanded, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10.0),
          border: const Border(
            top: BorderSide(color: Color.fromARGB(255, 56, 80, 88), width: 1.0),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style: const TextStyle(
                    color: Color.fromARGB(255, 226, 182, 167), fontSize: 16.0),
              ),
              Icon(
                isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: const Color.fromARGB(255, 226, 182, 167),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableContent(SetModel set) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 56, 80, 88),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${set.id ?? 'Unknown ID'} RPE: @${set.rpe ?? 'N/A'} Reps: ${set.reps ?? 'N/A'} KG: ${set.kg ?? 'N/A'}',
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
