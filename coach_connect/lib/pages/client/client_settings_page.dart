import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientSettingsPage extends StatefulWidget {
  final String userId;

  const ClientSettingsPage({super.key, required this.userId});

  @override
  State<ClientSettingsPage> createState() => _ClientSettingsPageState();
}

class _ClientSettingsPageState extends State<ClientSettingsPage> {
  bool isLoading = true;
  Map<String, dynamic>? userInfo;
  String? coachUsername;
  int workoutCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        userInfo = userDoc.data();
        var coachId = userInfo?['coachId'];

        if (coachId != null && coachId.isNotEmpty) {
          var coachDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(coachId)
              .get();
          if (coachDoc.exists) {
            coachUsername = coachDoc['username'];
          }
        }

        workoutCount = (userInfo?['workoutIds'] as List?)?.length ?? 0;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Settings",
            style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
          ),
          backgroundColor: const Color.fromARGB(255, 28, 40, 44),
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 226, 182, 167),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 226, 182, 167),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                "Name",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['name'] ?? 'N/A',
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Age",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['age']?.toString() ?? 'N/A',
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Username",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['username'] ?? 'N/A',
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Email",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['email'] ?? 'N/A',
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Account Type",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['accountType'] ?? 'N/A',
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Coach Username",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                coachUsername ?? 'No coach assigned',
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Number of Workouts",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                workoutCount.toString(),
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
