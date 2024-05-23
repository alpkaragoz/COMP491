import 'package:coach_connect/models/day.dart';
import 'package:coach_connect/pages/client/client_workout/client_workout_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientMyWorkoutsDaysPage extends StatefulWidget {
  final ClientHomeViewModel viewModel;
  final String workoutId;
  final String weekId;

  const ClientMyWorkoutsDaysPage({
    Key? key,
    required this.viewModel,
    required this.workoutId,
    required this.weekId,
  }) : super(key: key);

  @override
  _ClientMyWorkoutsDaysPageState createState() =>
      _ClientMyWorkoutsDaysPageState();
}

class _ClientMyWorkoutsDaysPageState extends State<ClientMyWorkoutsDaysPage> {
  late Future<List<DayModel>> _daysFuture;

  @override
  void initState() {
    super.initState();
    _daysFuture = widget.viewModel.getDays(widget.workoutId, widget.weekId);
  }

  void _markDayAsCompleted(String dayId) {
    setState(() {
      _daysFuture = _daysFuture.then((days) {
        return days.map((day) {
          if (day.id == dayId) {
            day = day.copyWith(completed: true);
          }
          return day;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Days',
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 226, 182, 167)),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: FutureBuilder<List<DayModel>>(
        future: _daysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 226, 182, 167)));
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error fetching days',
                    style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No days available',
                    style: TextStyle(color: Colors.white)));
          } else {
            final days = snapshot.data!;
            return ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: Color.fromARGB(255, 56, 80, 88), width: 1.0),
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
                              const SnackBar(
                                  content: Text('Invalid day ID',
                                      style: TextStyle(color: Colors.red))),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 56, 80, 88),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              day.name,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 226, 182, 167)),
                            ),
                            if (day.completed)
                              const Icon(
                                Icons.check,
                                color: Color.fromARGB(255, 226, 182, 167),
                              ),
                          ],
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
        builder: (context) => ClientWorkoutPage(
          viewModel: widget.viewModel,
          workoutId: widget.workoutId,
          weekId: widget.weekId,
          dayId: dayId,
          onWorkoutComplete: () {
            _markDayAsCompleted(dayId);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
