import 'package:coach_connect/models/user_account.dart';
import 'package:coach_connect/pages/coach/coach_workout/coach_workoutIds.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:flutter/material.dart';

class CoachWorkoutClientsPage extends StatelessWidget {
  final CoachHomeViewModel viewModel;

  const CoachWorkoutClientsPage({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clientList = viewModel.user!.clientIds;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Clients',
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color.fromARGB(255, 226, 182, 167), width: 1.0),
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
                      builder: (context, AsyncSnapshot<UserAccount?> snapshot) {
                        final clientName = snapshot.data?.name ?? 'Loading...';
                        final clientId = snapshot.data?.id;
                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color.fromARGB(255, 226, 182, 167), width: 1.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (clientId != null) {
                                  navigateToWorkoutsIdPage(context, clientId.toString());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                                minimumSize: const Size(double.infinity, 48),
                              ),
                              child: snapshot.connectionState != ConnectionState.waiting
                                  ? Text(
                                      clientName,
                                      style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                                    )
                                  : const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 226, 182, 167)),
                                    ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToWorkoutsIdPage(BuildContext context, String id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoachWorkoutIdsPage(viewModel: viewModel, clientId: id),
      ),
    );
  }
}
