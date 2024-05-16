import 'package:coach_connect/pages/client/chat_list_page.dart';
import 'package:coach_connect/pages/client/client_myworkouts_weekly_page.dart';
import 'package:coach_connect/pages/client/client_settings_page.dart';
import 'package:coach_connect/pages/client/mycoach_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({
    super.key,
    required this.viewModel,
  });

  final ClientHomeViewModel viewModel;

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  String? loadingCardTitle;

  void setLoadingCard(String? title) {
    setState(() {
      loadingCardTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.red,
            onPressed: () => _showSignOutConfirmation(context),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome, ${widget.viewModel.user.name}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 226, 182, 167),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: <Map<String, dynamic>>[
                  {'title': 'My Workouts', 'icon': Icons.fitness_center},
                  {'title': 'Chat', 'icon': Icons.chat},
                  {'title': 'My Coach', 'icon': Icons.person},
                  {'title': 'Settings', 'icon': Icons.settings},
                ]
                    .map((item) =>
                        _buildCard(item['title'], item['icon'], context))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, BuildContext context) {
    return InkWell(
      onTap: () async {
        setLoadingCard(title);
        if (title == "My Coach") {
          await navigateToCoachDetails(context);
        } else if (title == "My Workouts") {
          await navigateToClientMyWorkoutsWeeklyPage(context);
        } else if (title == "Chat") {
          await navigateToChat(context);
        } else if (title == "Settings") {
          await navigateToSettings(context);
        }
        setLoadingCard(null);
      },
      child: Card(
        elevation: 4.0,
        color: const Color.fromARGB(255, 56, 80, 88),
        child: Center(
          child: loadingCardTitle == title
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 226, 182, 167),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon,
                          size: 48,
                          color: const Color.fromARGB(255, 226, 182, 167)),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 226, 182, 167),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> navigateToCoachDetails(BuildContext context) async {
    await widget.viewModel.refreshUserData(); // Refresh user data
    await widget.viewModel.getUserAccountOfRequest();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyCoachPage(viewModel: widget.viewModel),
        ),
      );
    }
  }

  Future<void> navigateToClientMyWorkoutsWeeklyPage(
      BuildContext context) async {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ClientMyWorkoutsWeeklyPage(viewModel: widget.viewModel),
        ),
      );
    }
  }

  Future<void> navigateToChat(BuildContext context) async {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChatListPage(currentUserId: widget.viewModel.user.id),
        ),
      );
    }
  }

  Future<void> navigateToSettings(BuildContext context) async {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ClientSettingsPage(userId: widget.viewModel.user.id),
        ),
      );
    }
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sign Out',
            style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
          ),
          backgroundColor: const Color.fromARGB(255, 56, 80, 88),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await widget.viewModel.signOut(); // Proceed with sign out
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Dismiss the dialog but stay in the app
              },
              child: const Text(
                'No',
                style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
          ],
        );
      },
    );
  }
}
