import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoachSettingsPage extends StatefulWidget {
  final String userId;

  const CoachSettingsPage({super.key, required this.userId});

  @override
  State<CoachSettingsPage> createState() => _CoachSettingsPageState();
}

class _CoachSettingsPageState extends State<CoachSettingsPage> {
  bool isLoading = true;
  Map<String, dynamic>? userInfo;
  String? coachUsername;
  int clientCount = 0;

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

        clientCount = (userInfo?['clientIds'] as List?)?.length ?? 0;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching user info: $e");
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
          title: const Text("Settings"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text("Name"),
              subtitle: Text(userInfo?['name'] ?? 'N/A'),
            ),
            ListTile(
              title: const Text("Age"),
              subtitle: Text(userInfo?['age']?.toString() ?? 'N/A'),
            ),
            ListTile(
              title: const Text("Username"),
              subtitle: Text(userInfo?['username'] ?? 'N/A'),
            ),
            ListTile(
              title: const Text("Email"),
              subtitle: Text(userInfo?['email'] ?? 'N/A'),
            ),
            ListTile(
              title: const Text("Account Type"),
              subtitle: Text(userInfo?['accountType'] ?? 'N/A'),
            ),
            ListTile(
              title: const Text("Number of Clients"),
              subtitle: Text(clientCount.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
