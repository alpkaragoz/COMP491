import 'dart:async';
import 'package:flutter/material.dart';
import 'package:coach_connect/models/exercise.dart';
import 'package:coach_connect/models/set.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientInteractiveWorkoutPage extends StatefulWidget {
  final ClientHomeViewModel viewModel;
  final String workoutId;
  final String weekId;
  final String dayId;
  final VoidCallback onWorkoutComplete;

  const ClientInteractiveWorkoutPage({
    Key? key,
    required this.viewModel,
    required this.workoutId,
    required this.weekId,
    required this.dayId,
    required this.onWorkoutComplete,
  }) : super(key: key);

  @override
  _ClientInteractiveWorkoutPageState createState() => _ClientInteractiveWorkoutPageState();
}

class _ClientInteractiveWorkoutPageState extends State<ClientInteractiveWorkoutPage> {
  bool _isLoading = true;
  List<ExerciseModel> _exercises = [];
  Map<String, List<SetModel>> _exerciseSets = {};
  int _currentSetIndex = 0;
  int _currentExerciseIndex = 0;
  bool _isInBreak = false;
  Timer? _timer;
  int _breakTime = 120;

  @override
  void initState() {
    super.initState();
    fetchExercisesAndSets();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  void _startBreak() {
    setState(() {
      _isInBreak = true;
      _breakTime = 120; // 2 minutes break
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_breakTime > 0) {
          _breakTime--;
        } else {
          _timer?.cancel();
          _isInBreak = false;
          _nextSetOrExercise();
        }
      });
    });
  }

  void _nextSetOrExercise() {
    setState(() {
      if (_currentSetIndex < (_exerciseSets[_exercises[_currentExerciseIndex].id!] ?? []).length - 1) {
        _currentSetIndex++;
      } else {
        if (_currentExerciseIndex < _exercises.length - 1) {
          _currentExerciseIndex++;
          _currentSetIndex = 0;
        } else {
          widget.onWorkoutComplete();
          Navigator.pop(context);
        }
      }
    });
  }

  void _skipTime() {
    _timer?.cancel();
    setState(() {
      _isInBreak = false;
      _nextSetOrExercise();
    });
  }

  Widget _buildBreakWidget() {
  String nextUpText;

  if (_currentSetIndex < (_exerciseSets[_exercises[_currentExerciseIndex].id!] ?? []).length - 1) {
    nextUpText = 'Next up: ${_exerciseSets[_exercises[_currentExerciseIndex].id!]![_currentSetIndex + 1].reps} Reps x ${_exerciseSets[_exercises[_currentExerciseIndex].id!]![_currentSetIndex + 1].kg}kg';
  } else if (_currentExerciseIndex < _exercises.length - 1) {
    nextUpText = 'Next up: ${_exercises[_currentExerciseIndex + 1].name}';
  } else {
    nextUpText = 'Workout Complete!';
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Break',
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 226, 182, 167)),
        textAlign: TextAlign.center, // Center horizontally
      ),
      const SizedBox(height: 16),
      Center( // Center the break time text
        child: Text(
          '${(_breakTime ~/ 60).toString().padLeft(2, '0')}:${(_breakTime % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 226, 182, 167)),
        ),
      ),
      const SizedBox(height: 60),
      Opacity(
        opacity: 0.5,
        child: Text(
          nextUpText,
          style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 226, 182, 167)),
          textAlign: TextAlign.center, // Center horizontally
        ),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: _skipTime,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 56, 80, 88),
        ),
        child: const Text(
          'Skip Time',
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
      ),
    ],
  );
}


  Widget _buildSetWidget(SetModel set, ExerciseModel exercise) {
  String nextUpText;

  if (_currentSetIndex < (_exerciseSets[exercise.id!] ?? []).length - 1) {
    nextUpText = 'Next up: 2:00 Break';
  } else if (_currentExerciseIndex < _exercises.length - 1) {
    nextUpText = 'Next up: 2:00 Break';
  } else {
    nextUpText = 'Workout Complete!';
  }

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
      children: [
        Text(
          'Set ${_currentSetIndex + 1}',
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 226, 182, 167)),
        ),
        const SizedBox(height: 8),
        Text(
          exercise.name ?? 'Unknown Exercise',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 226, 182, 167)),
        ),
        const SizedBox(height: 16),
        Text(
          '${set.reps} Reps x ${set.kg} kg',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 226, 182, 167)),
        ),
        const SizedBox(height: 60),
        Opacity(
          opacity: 0.5,
          child: Text(
            nextUpText,
            style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 226, 182, 167)),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (nextUpText == 'Workout Complete!') {
              widget.onWorkoutComplete();
              Navigator.pop(context);
            } else {
              _startBreak();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 56, 80, 88),
          ),
          child: Text(
            nextUpText == 'Workout Complete!' ? 'Finish Workout' : 'Next',
            style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildNoSetsWidget(ExerciseModel exercise) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      children: [
        Text(
          exercise.name ?? 'Unknown Exercise',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 226, 182, 167)),
          textAlign: TextAlign.center, // Center horizontally
        ),
        const SizedBox(height: 16),
        const Text(
          'No sets assigned',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 226, 182, 167)),
          textAlign: TextAlign.center, // Center horizontally
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _nextSetOrExercise,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 56, 80, 88),
          ),
          child: const Text(
            'Next Exercise',
            style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
          ),
        ),
      ],
    ),
  );
}


  @override
Widget build(BuildContext context) {
  if (_isLoading) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 40, 44),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  if (_exercises.isEmpty) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Interactive Workout',
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Center(
        child: Text(
          'No exercises assigned',
          style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 226, 182, 167)),
        ),
      ),
    );
  }

  final currentExercise = _exercises[_currentExerciseIndex];
  final sets = _exerciseSets[currentExercise.id!] ?? [];

  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Interactive Workout',
        style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 226, 182, 167),
      ),
    ),
    backgroundColor: const Color.fromARGB(255, 28, 40, 44),
    body: _isInBreak
      ? _buildBreakWidget()
      : sets.isEmpty
        ? _buildNoSetsWidget(currentExercise)
        : _buildSetWidget(sets[_currentSetIndex], currentExercise),
  );
}
}
