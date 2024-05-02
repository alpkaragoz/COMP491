import 'package:coach_connect/models/request.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';

class CoachWorkoutPage extends StatelessWidget {
  final CoachHomeViewModel viewModel;

  const CoachWorkoutPage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    List<String> topStrings = ['Set', 'RPE', 'Reps', 'KG', 'Video'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Workout Add Page'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        itemCount: 30, // 5 (top row) + 5 (left column) + 5x5 (rest of the grid)
        itemBuilder: (BuildContext context, int index) {
          if (index < 5) {
            // Top row with different strings
            return Center(
              child: Text(topStrings[index]),
            );
          } else if (index % 5 == 0) {
            // First column with strings
            return Center(
              child: Text('${index ~/ 5}'),
            );
          } else if (index % 5 == 4) {
            // Last column (column E) with "+" buttons
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add your logic for the "+" button here
                },
                child: Icon(Icons.add),
              ),
            );
          } else {
            // Text fields for the rest of the grid
            return Center(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}