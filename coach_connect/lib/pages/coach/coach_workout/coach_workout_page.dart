import 'package:coach_connect/models/request.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';

class CoachWorkoutPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;

  const CoachWorkoutPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  _CoachWorkoutPageState createState() => _CoachWorkoutPageState();
}

class _CoachWorkoutPageState extends State<CoachWorkoutPage> {
  List<List<String>> workoutData = [
    ['Set', 'RPE', 'Reps', 'KG', 'Video'],
    ['1', '', '', '', ''],
  ];
  int setCounter = 2;

  void addRow() {
    setState(() {
      workoutData.add([setCounter.toString(), '', '', '', '']);
      setCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Workout Add Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: workoutData.length * 5,
              itemBuilder: (BuildContext context, int index) {
                int rowIndex = index ~/ 5;
                int columnIndex = index % 5;
                if (rowIndex == 0) {
                  return Center(
                    child: Text(workoutData[rowIndex][columnIndex]),
                  );
                } else if (columnIndex == 0) {
                  return Center(
                    child: Text(workoutData[rowIndex][columnIndex]),
                  );
                } else if (columnIndex == 4) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your logic for the video button here
                      },
                      child: Icon(Icons.add),
                    ),
                  );
                } else {
                  return Center(
                    child: TextField(
                      onChanged: (text) {
                        workoutData[rowIndex][columnIndex] = text;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addRow();
            },
            child: Text('Add Set'),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                // Add your logic for the button at the bottom here
              },
              child: Text('Create Exercise'),
            ),
          ),
        ],
      ),
    );
  }
}