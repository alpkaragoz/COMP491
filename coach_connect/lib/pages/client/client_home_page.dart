import 'package:coach_connect/pages/client/client_workout_page.dart';
import 'package:coach_connect/pages/client/mycoach_page.dart';
import 'package:coach_connect/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({
    super.key,
    required this.viewModel,
  });
  final ClientHomeViewModel viewModel;

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome, ${viewModel.user.name}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: <String>[
                  'My Workouts',
                  'Chat',
                  'My Coach',
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
    return InkWell(
      onTap: () {
        if (title == "My Coach") {
          navigateToCoachDetails(context);
        }
        else if (title == "My Workouts") {
          navigateToClientWorkoutPage(context);
        }
      },
      child: Card(
        elevation: 4.0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void navigateToCoachDetails(BuildContext context) async {
    await viewModel.refreshUserData(); // Refresh user data
    await viewModel.getUserAccountOfRequest();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyCoachPage(viewModel: viewModel),
      ),
    );
  }

  void navigateToClientWorkoutPage(BuildContext context) async {
    // await viewModel.refreshUserData(); // Refresh user data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientWorkoutPage(viewModel: viewModel),
      ),
    );
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dismiss the dialog
                await viewModel.signOut(); // Proceed with sign out
                MaterialPageRoute(builder: (context) => const LoginPage());
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Dismiss the dialog but stay in the app
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
