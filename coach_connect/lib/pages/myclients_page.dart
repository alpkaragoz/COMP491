import 'package:flutter/material.dart';
import 'package:coach_connect/models/request.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';

class MyClientsPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;

  const MyClientsPage({super.key, required this.viewModel});

  @override
  State<MyClientsPage> createState() => _MyClientsPageState();
}

class _MyClientsPageState extends State<MyClientsPage> {
  bool _useOrangeBlackTheme = false;

  ThemeData get _currentTheme {
    return _useOrangeBlackTheme ? ThemeData(
      primarySwatch: Colors.orange,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.orange.shade50,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.orange,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black),
        headline6: TextStyle(color: Colors.white),
      ),
    ) : Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _currentTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Clients and Requests"),
          actions: [
            IconButton(
              icon: Icon(_useOrangeBlackTheme ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() {
                _useOrangeBlackTheme = !_useOrangeBlackTheme;
              }),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Clients", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: widget.viewModel.clients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.viewModel.clients[index]?.username ?? "no data found"),
                    subtitle: const Text("Details about the client..."),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Pending Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: widget.viewModel.requests.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.viewModel.requests[index]?.senderUsername ?? "no data found"),
                    subtitle: const Text("Request details..."),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => _acceptRequest(widget.viewModel.requests[index]!),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _denyRequest(widget.viewModel.requests[index]!),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _acceptRequest(Request request) async {
    setState(() => _isLoading = true);
    var message = await widget.viewModel.acceptRequest(request);
    _showSnackBar(message);
    setState(() => _isLoading = false);
  }

  void _denyRequest(Request request) async {
    setState(() => _isLoading = true);
    var message = await widget.viewModel.denyRequest(request);
    _showSnackBar(message);
    setState(() => _isLoading = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelUpdated);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelUpdated);
    super.dispose();
  }

  void _onViewModelUpdated() {
    if (mounted) {
      setState(() {});
    }
  }
}
