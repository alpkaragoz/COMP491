import 'package:coach_connect/pages/client/client_home_page.dart';
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
        title: const Text(
          "Coach Details",
          style: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 226, 182, 167),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
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
                            hintStyle: TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                            filled: true,
                            fillColor: Color.fromARGB(255, 56, 80, 88),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _sendRequest,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                          backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Color.fromARGB(255, 226, 182, 167))
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _cancelRequest,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                          backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Color.fromARGB(255, 226, 182, 167))
                            : const Text("Cancel"),
                      ),
                    ],
                  )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox.shrink(),
                  Text(
                    "Coach Name: ${widget.viewModel.currentCoachName}",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  // More coach details can be added here
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await ClientHomeViewModel(widget.viewModel.user)
                            .removeCoachFromClient(
                                clientId: widget.viewModel.user.id,
                                coachId: widget.viewModel.user.coachId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientHomePage(viewModel: widget.viewModel),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                        backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Color.fromARGB(255, 226, 182, 167))
                          : const Text("Leave Coach"),
                    ),
                  ),
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

  void _setLoading(bool bool) {
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
