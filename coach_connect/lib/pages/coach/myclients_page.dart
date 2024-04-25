import 'package:coach_connect/models/request.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';

class MyClientsPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;

  const MyClientsPage({super.key, required this.viewModel});

  @override
  State<MyClientsPage> createState() => _MyClientsPageState();
}

class _MyClientsPageState extends State<MyClientsPage> {
  final TextEditingController _requestController = TextEditingController();
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Clients and Requests"),
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
    );
  }

  void _setLoading(bool bool) {
    setState(() {
      _isLoading = bool;
    });
  }

  void _acceptRequest(Request request) async {
    _setLoading(true);
    var message = await widget.viewModel.acceptRequest(request);
    _showSnackBar(message);
    _setLoading(false);
  }

  void _denyRequest(Request request) {
    _setLoading(true);
    var message = widget.viewModel.denyRequest(request);
    _showSnackBar(message);
    _setLoading(false);
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
    _requestController.dispose();
    super.dispose();
  }

  void _onViewModelUpdated() {
    if (mounted) {
      setState(() {});
    }
  }
}
