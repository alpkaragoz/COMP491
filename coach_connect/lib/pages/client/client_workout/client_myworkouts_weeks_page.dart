import 'package:coach_connect/pages/client/client_workout/client_myworkouts_days_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientMyWorkoutsWeeksPage extends StatefulWidget {
  final ClientHomeViewModel viewModel;
  final String workoutId;

  const ClientMyWorkoutsWeeksPage({Key? key, required this.viewModel, required this.workoutId})
      : super(key: key);

  @override
  _ClientMyWorkoutsWeeksPageState createState() => _ClientMyWorkoutsWeeksPageState();
}

class _ClientMyWorkoutsWeeksPageState extends State<ClientMyWorkoutsWeeksPage> {
  List<String> weeks = [];
  bool hasWeeks = false;

  @override
  void initState() {
    super.initState();
    fetchWeeks();
  }

  Future<void> fetchWeeks() async {
    try {
      final fetchedWeeks = await widget.viewModel.generateWeekIndices(widget.workoutId);
      setState(() {
        weeks = fetchedWeeks.map((index) => 'Week $index').toList();
        hasWeeks = weeks.isNotEmpty;
      });
    } catch (e) {
      print('Error fetching weeks: $e');
      setState(() {
        weeks = [];
        hasWeeks = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weeks'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          hasWeeks
              ? Expanded(
                  child: ListView.builder(
                    itemCount: weeks.length,
                    itemBuilder: (context, index) {
                      final weekName = weeks[index];
                      final weekId = 'Week${index + 1}'; // Assuming weekId follows this format
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              navigateToClientMyWorkoutsDaysPage(context, weekId);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 48)),
                            ),
                            child: Text(
                              weekName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text('No weeks currently'),
                ),
        ],
      ),
    );
  }

  void navigateToClientMyWorkoutsDaysPage(BuildContext context, String weekId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientMyWorkoutsDaysPage(viewModel: widget.viewModel, workoutId: widget.workoutId, weekId: weekId)
      ),
    );
  }
}
