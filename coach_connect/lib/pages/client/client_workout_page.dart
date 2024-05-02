import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientWorkoutPage extends StatelessWidget {
  const ClientWorkoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> topStrings = ['Set', 'RPE', 'Reps', 'KG', 'Video'];
    List<String> workoutDataList = []; // boş şu an
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Workout Page'),
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
    int workoutIndex = index ~/ 5 - 1; // Adjust index to match workoutDataList
    String workoutData = workoutDataList.length > workoutIndex ? workoutDataList[workoutIndex] : "";
    return Center(
      child: Text(workoutData),
    );
  }
},
      ),
    );
  }
}