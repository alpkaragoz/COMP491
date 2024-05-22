import 'package:flutter/material.dart';
import 'package:coach_connect/models/exercise.dart';
import 'package:coach_connect/models/set.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientWorkoutPage extends StatefulWidget {
  final ClientHomeViewModel viewModel;
  final String workoutId;
  final String weekId;
  final String dayId;

  const ClientWorkoutPage({
    Key? key,
    required this.viewModel,
    required this.workoutId,
    required this.weekId,
    required this.dayId,
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
        SnackBar(content: Text('Error fetching exercises and sets')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          color: Colors.black,
                          thickness: 1.0,
                        ),
                      ),
                      ..._exercises.map((exercise) {
                        return _buildExerciseItem(exercise);
                      }).toList(),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your logic for starting the workout here
                      },
                      child: Text('Start Workout'),
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
            _buildDayButton(exercise.name ?? 'Unknown Exercise', Colors.black, isExpanded, () {
              setState(() {
                isExpanded = !isExpanded;
              });
            }),
            if (isExpanded) ...?_exerciseSets[exercise.id]?.map((set) {
              return _buildExpandableContent(set);
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildDayButton(String day, Color buttonColor, bool isExpanded, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border(
            top: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              Icon(
                isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white,
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
          color: Colors.black87,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${set.id ?? 'Unknown ID'} RPE: @${set.rpe ?? 'N/A'} Reps: ${set.reps ?? 'N/A'} KG: ${set.kg ?? 'N/A'}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
