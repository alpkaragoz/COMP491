import 'package:coach_connect/pages/coach/coach_workout/coach_workoutIds.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:flutter/material.dart';

class CoachWorkoutClientsPage extends StatelessWidget {
  final CoachHomeViewModel viewModel;

  const CoachWorkoutClientsPage({Key? key, required this.viewModel})
      : super(key: key);

      

  @override
Widget build(BuildContext context) {
  final clientList = viewModel.user!.clientIds;

  return Scaffold(
    appBar: AppBar(
      title: const Text('My Clients'),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black, width: 1.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: clientList.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: CoachHomeViewModel(viewModel.user).getUser(clientList[index]),
                    builder: (context, snapshot) {
                      final clientName = snapshot.data?.name;
                      return ElevatedButton(
                        onPressed: () {
                          // Handle button click here
                          // You can navigate to a new page or perform any other action
                          navigateToWorkoutsIdPage(context);
                        },
                        child: Text(clientName.toString()),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        // Add other widgets below the button if needed
      ],
    ),
  );
}


  void navigateToWorkoutsIdPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CoachWorkoutIdsPage(viewModel: viewModel)),
    );
  }
}