import 'package:flutter/material.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';

class MyCoachPage extends StatefulWidget {
  final ClientHomeViewModel viewModel;

  const MyCoachPage({super.key, required this.viewModel});

  @override
  State<MyCoachPage> createState() => _MyCoachPageState();
}

class _MyCoachPageState extends State<MyCoachPage> {
  final TextEditingController _requestController = TextEditingController();
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coach Details"),
      ),
      body: Center(
        child: widget.viewModel.user.coachId.isEmpty
            ? widget.viewModel.pendingRequest == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _requestController,
                          decoration: const InputDecoration(
                            hintText:
                                "Enter the username of the coach you want to add",
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _isLoading ? null : _sendRequest();
                        },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Add Coach"),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Request sent to: ${widget.viewModel.pendingRequest!.receierUsername}",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _isLoading ? null : _cancelRequest();
                        },
                        child: _isLoading ? const CircularProgressIndicator() : const Text("Cancel"),
                      ),
                    ],
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Coach Name: ${widget.viewModel.currentCoachName}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  // More coach details can be added here
                ],
              ),
      ),
    );
  }

  void _sendRequest() async {
    _setLoading(true);
    var message =
        await widget.viewModel.sendRequestToCoach(_requestController.text);
    _setLoading(false);
    _showSnackBar(message);
  }

  void _cancelRequest() async {
    _setLoading(true);
    var message = await widget.viewModel.cancelRequestFromClientToCoach();
   _setLoading(false);
    _showSnackBar(message);
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

  void _setLoading(bool bool){
    _isLoading = bool;
    setState(() {});
  }

  void _onViewModelUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
