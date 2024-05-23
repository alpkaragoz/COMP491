import 'package:coach_connect/models/request.dart';
import 'package:coach_connect/models/user_account.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyClientsPage extends StatefulWidget {
  final CoachHomeViewModel viewModel;

  const MyClientsPage({super.key, required this.viewModel});

  @override
  State<MyClientsPage> createState() => _MyClientsPageState();
}

class _MyClientsPageState extends State<MyClientsPage> {
  final TextEditingController _requestController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Clients and Requests",
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Clients",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: widget.viewModel.clients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${index + 1}. ${widget.viewModel.clients[index]?.username ?? "no data found"}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 226, 182, 167),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _showRemoveClientDialog(widget.viewModel.clients[index]!),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: Colors.white),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Pending Requests",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: widget.viewModel.requests.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    widget.viewModel.requests[index]?.senderUsername ??
                        "no data found",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 226, 182, 167)),
                  ),
                  subtitle: const Text(
                    "Request details...",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () =>
                            _acceptRequest(widget.viewModel.requests[index]!),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () =>
                            _denyRequest(widget.viewModel.requests[index]!),
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

  void _setLoading(bool loading) {
    setState(() {});
  }

  void _acceptRequest(Request request) async {
    _setLoading(true);
    var message = await widget.viewModel.acceptRequest(request);
    _showSnackBar(message);
    _setLoading(false);
  }

  void _denyRequest(Request request) async {
    _setLoading(true);
    var message = await widget.viewModel.denyRequest(request);
    _showSnackBar(message);
    _setLoading(false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showRemoveClientDialog(UserAccount client) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Client"),
          content: const Text("Are you sure you want to remove this client?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Remove"),
              onPressed: () {
                Navigator.of(context).pop();
                _removeClient(client);
              },
            ),
          ],
        );
      },
    );
  }

  void _removeClient(UserAccount client) async {
    _setLoading(true);
    try {
      // Remove client ID from coach's clientIds array
      await FirebaseFirestore.instance.collection('users').doc(widget.viewModel.user!.id).update({
        'clientIds': FieldValue.arrayRemove([client.id])
      });

      // Remove coachId from client's document
      await FirebaseFirestore.instance.collection('users').doc(client.id).update({
        'coachId': FieldValue.delete()
      });
      await widget.viewModel.getClientObjectsForCoach();
      await widget.viewModel.getPendingRequestsForCoach();
      _showSnackBar("Client removed successfully");
    } catch (e) {
      _showSnackBar("Error removing client: $e");
    }
    _setLoading(false);
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
