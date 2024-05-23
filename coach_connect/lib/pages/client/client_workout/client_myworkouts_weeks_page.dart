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
  List<bool> weeksCompleted = [];
  bool hasWeeks = false;

  @override
  void initState() {
    super.initState();
    fetchWeeks();
  }

  Future<void> fetchWeeks() async {
    try {
      final fetchedWeeks = await widget.viewModel.generateWeekIndices(widget.workoutId);
      final completedStatus = await Future.wait(fetchedWeeks.map((index) => _checkWeekCompletion(index)));
      
      setState(() {
        weeks = fetchedWeeks.map((index) => 'Week $index').toList();
        weeksCompleted = completedStatus;
        hasWeeks = weeks.isNotEmpty;
      });
    } catch (e) {
      print('Error fetching weeks: $e');
      setState(() {
        weeks = [];
        weeksCompleted = [];
        hasWeeks = false;
      });
    }
  }

  Future<bool> _checkWeekCompletion(int weekIndex) async {
    try {
      final weekId = 'Week${weekIndex}'; // Generate weekId using the provided index
      final days = await widget.viewModel.getDays(widget.workoutId, weekId);
      bool allDaysCompleted = days.every((day) => day.completed);
      print('Week $weekId completion status: $allDaysCompleted'); // Debug statement
      return allDaysCompleted;
    } catch (e) {
      print('Error checking week completion: $e');
      return false;
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
                      final isCompleted = weeksCompleted[index];
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  weekName,
                                  style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                                ),
                                if (isCompleted)
                                  Icon(
                                    Icons.check,
                                    color: Color.fromARGB(255, 226, 182, 167),
                                  ),
                              ],
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
