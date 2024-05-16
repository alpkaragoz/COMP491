import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientWorkoutPage extends StatefulWidget {
  final ClientHomeViewModel viewModel;

  const ClientWorkoutPage({Key? key, required this.viewModel})
      : super(key: key);

  @override
  _ClientWorkoutPageState createState() => _ClientWorkoutPageState();
}

class _ClientWorkoutPageState extends State<ClientWorkoutPage> {
  bool _isExpandedMonday = false;
  bool _isExpandedFriday = false;
  bool _isExpandedSaturday = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client My Workouts Page'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    color: Colors.black,
                    thickness: 1.0,
                  ),
                ),
                _buildDayButton('Bench Press', Colors.black, _isExpandedMonday,
                    () {
                  setState(() {
                    _isExpandedMonday = !_isExpandedMonday;
                  });
                }),
                if (_isExpandedMonday)
                  _buildExpandableContent('Set:3 RPE:8 Reps:10 KG:60'),
                _buildDayButton('Chest Fly', Colors.black, _isExpandedFriday,
                    () {
                  setState(() {
                    _isExpandedFriday = !_isExpandedFriday;
                  });
                }),
                if (_isExpandedFriday)
                  _buildExpandableContent('Set:3 RPE:6 Reps:8 KG:50'),
                _buildDayButton(
                    'Triceps Extension', Colors.black, _isExpandedSaturday, () {
                  setState(() {
                    _isExpandedSaturday = !_isExpandedSaturday;
                  });
                }),
                if (_isExpandedSaturday)
                  _buildExpandableContent('Set:3 RPE:8 Reps:10 KG:60'),
                SizedBox(
                    height:
                        16.0), // Add some space between the content and the button
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 16.0), // Add additional padding if needed
              child: ElevatedButton(
                onPressed: () {
                  // Add your logic for starting the workout here
                },
                child: Text('Start Workout'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayButton(
      String day, Color buttonColor, bool isExpanded, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border(
            top: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              Icon(
                isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableContent(String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10.0), // Set border radius for curvy edges
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding to the black background
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  content,
                  style: TextStyle(color: Colors.white),
                ),
                // Add other widgets here if needed
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

}
