import 'package:coach_connect/pages/coach/coach_chat_list_page.dart';
import 'package:coach_connect/pages/coach/coach_settings_page.dart';
import 'package:coach_connect/pages/coach/coach_workout_page.dart';
import 'package:coach_connect/pages/coach/myclients_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';

class CoachHomePage extends StatelessWidget {
  const CoachHomePage({
    super.key,
    required this.viewModel,
  });

  final CoachHomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coach Home',
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.red,
            onPressed: () => _showSignOutConfirmation(context),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome, ${viewModel.user?.name}',
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
                children: <String>[
                  'Create/View Workouts',
                  'Chat',
                  'My Clients',
                  'Settings',
                ].map((title) => _buildCard(title, context)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, BuildContext context) {
    IconData iconData;
    switch (title) {
      case 'Create/View Workouts':
        iconData = Icons.fitness_center;
        break;
      case 'Chat':
        iconData = Icons.chat;
        break;
      case 'My Clients':
        iconData = Icons.people;
        break;
      case 'Settings':
        iconData = Icons.settings;
        break;
      default:
        iconData = Icons.help;
    }

    return InkWell(
      onTap: () {
        if (title == "My Clients") {
          navigateToClientDetails(context);
        } else if (title == "Create/View Workouts") {
          navigateToCoachWorkoutPage(context);
        } else if (title == "Chat") {
          navigateToChat(context);
        } else if (title == "Settings") {
          navigateToSettings(context);
        }
      },
      child: Card(
        color: const Color.fromARGB(255, 56, 80, 88),
        elevation: 4.0,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData,
                  size: 40, color: Color.fromARGB(255, 226, 182, 167)),
              const SizedBox(height: 8),
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
    );
  }

  void navigateToClientDetails(BuildContext context) async {
    await viewModel.getClientObjectsForCoach();
    await viewModel.getPendingRequestsForCoach();
    await viewModel.refreshUserData();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyClientsPage(viewModel: viewModel),
      ),
    );
  }

  void navigateToCoachWorkoutPage(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoachWorkoutPage(viewModel: viewModel),
      ),
    );
  }

  void navigateToChat(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoachChatListPage(coachId: viewModel.user!.id),
      ),
    );
  }

  void navigateToSettings(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoachSettingsPage(userId: viewModel.user!.id),
      ),
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sign Out',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 56, 80, 88),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await viewModel.signOut(); // Proceed with sign out
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Dismiss the dialog but stay in the app
              },
              child: const Text('No', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
