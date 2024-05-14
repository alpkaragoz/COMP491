import 'package:flutter/material.dart';

class SelectedWeeksPage extends StatefulWidget {
  final List<int> selectedWeeks;

  const SelectedWeeksPage({Key? key, required this.selectedWeeks})
      : super(key: key);

  @override
  _SelectedWeeksPageState createState() => _SelectedWeeksPageState();
}

class _SelectedWeeksPageState extends State<SelectedWeeksPage> {
  int selectedWeek = 1; // Initialize selectedWeek to 1
  int selectedDay = 1; // Initialize selectedWeek to 1
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Program'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.selectedWeeks.last, (index) {
                final week = index + 1;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedWeek = week;
                      });
                    },
                    child: Text('Week $week'),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectedWeeks.length,
              itemBuilder: (context, index) {
                final week = widget.selectedWeeks[index];
                return Column(
                  children: [
                    Text('Day $selectedDay'),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: DropdownButton<int>(
                        value: selectedWeek,
                        onChanged: (value) {
                          setState(() {
                            selectedWeek = value!;
                          });
                        },
                        items: List.generate(
                          7,
                          (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text('Exercise ${index + 1}'),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
