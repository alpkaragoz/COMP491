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
        clientCount = (userInfo?['clientIds'] as List?)?.length ?? 0;
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
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['name'] ?? 'N/A',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Age",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['age']?.toString() ?? 'N/A',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Username",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['username'] ?? 'N/A',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Email",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['email'] ?? 'N/A',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Account Type",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userInfo?['accountType'] ?? 'N/A',
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: const Text(
                "Number of Clients",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                clientCount.toString(),
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
