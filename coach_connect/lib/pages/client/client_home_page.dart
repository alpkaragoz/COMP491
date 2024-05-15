import 'package:coach_connect/pages/client/chat_list_page.dart';
import 'package:coach_connect/pages/client/client_myworkouts_weekly_page.dart';
import 'package:coach_connect/pages/client/mycoach_page.dart';
import 'package:coach_connect/pages/login_page.dart';
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
              'Welcome, ${widget.viewModel.user.name}',
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
        } else if (title == "My Workouts") {
          navigateToClientMyWorkoutsWeeklyPage(context);
        } else if (title == "Chat") {
          navigateToChat(context);
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

  void navigateToClientMyWorkoutsWeeklyPage(BuildContext context) async {
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

  void navigateToChat(BuildContext context) async {
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
                await widget.viewModel.signOut(); // Proceed with sign out
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
