import 'package:coach_connect/models/day.dart';
import 'package:coach_connect/pages/client/client_workout/client_workout_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientMyWorkoutsDaysPage extends StatelessWidget {
  final ClientHomeViewModel viewModel;
  final String workoutId;
  final String weekId;

  const ClientMyWorkoutsDaysPage({Key? key, required this.viewModel, required this.workoutId, required this.weekId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Days'),
      ),
      body: FutureBuilder<List<DayModel>>(
        future: viewModel.getDays(workoutId, weekId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching days'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No days available'));
          } else {
            final days = snapshot.data!;
            return ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (day.id != null) {
                            navigateToClientWorkoutPage(context, day.id!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid day ID')),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(double.infinity, 48)),
                        ),
                        child: Text(
                          day.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void navigateToClientWorkoutPage(BuildContext context, String dayId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientWorkoutPage(viewModel: viewModel, workoutId: workoutId, weekId: weekId, dayId: dayId)
      ),
    );
  }
}
