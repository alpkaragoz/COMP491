import 'package:coach_connect/pages/coach/myclients_page.dart';
import 'package:coach_connect/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';

class CoachHomePage extends StatefulWidget {
  const CoachHomePage({Key? key, required this.viewModel}) : super(key: key);

  final CoachHomeViewModel viewModel;

  @override
  _CoachHomePageState createState() => _CoachHomePageState();
}

class _CoachHomePageState extends State<CoachHomePage> {
  bool _useOrangeBlackTheme = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = _useOrangeBlackTheme ? ThemeData(
      primarySwatch: Colors.orange,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Colors.orange,
        shadowColor: Colors.black,
      ),
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white),
        bodyText2: TextStyle(color: Colors.black),
      ),
    ) : Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.viewModel.user?.name}'),
        actions: [
          IconButton(
            icon: Icon(_useOrangeBlackTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _useOrangeBlackTheme = !_useOrangeBlackTheme;
              });
            },
          ),
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
                ].map((title) => _buildCard(title, context, theme)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: () {
        if (title == "My Clients") {
          navigateToClientDetails(context);
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyText2?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigateToClientDetails(BuildContext context) async {
    await widget.viewModel.getClientObjectsForCoach();
    await widget.viewModel.getPendingRequestsForCoach();
    await widget.viewModel.refreshUserData();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyClientsPage(viewModel: widget.viewModel),
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
                await widget.viewModel.signOut(); // Proceed with sign out
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog but stay in the app
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
