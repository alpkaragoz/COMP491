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
        title: const Text(
          'Weeks',
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
          hasWeeks
              ? Expanded(
                  child: ListView.builder(
                    itemCount: weeks.length,
                    itemBuilder: (context, index) {
                      final weekName = weeks[index];
                      final weekId = 'Week${index + 1}'; // Assuming weekId follows this format
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color.fromARGB(255, 56, 80, 88), width: 1.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              navigateToClientMyWorkoutsDaysPage(context, weekId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: Text(
                              weekName,
                              style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text('No weeks currently', style: TextStyle(color: Colors.white)),
                ),
        ],
      ),
    );
  }

  void navigateToClientMyWorkoutsDaysPage(BuildContext context, String weekId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientMyWorkoutsDaysPage(viewModel: widget.viewModel, workoutId: widget.workoutId, weekId: weekId),
      ),
    );
  }
}
