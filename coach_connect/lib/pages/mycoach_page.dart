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
          title: const Text("Coach Details"),
          actions: [
            IconButton(
              icon: Icon(_useOrangeBlackTheme ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => setState(() {
                _useOrangeBlackTheme = !_useOrangeBlackTheme;
              }),
            ),
          ],
        ),
        body: Center(
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.viewModel.user.coachId.isEmpty) {
      return widget.viewModel.pendingRequest == null
          ? _buildRequestForm()
          : _buildPendingRequestInfo();
    } else {
      return _buildCoachInfo();
    }
  }

  Widget _buildRequestForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _requestController,
            decoration: const InputDecoration(
              hintText: "Enter the username of the coach you want to add",
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _sendRequest,
          child: _isLoading ? const CircularProgressIndicator() : const Text("Add Coach"),
        ),
      ],
    );
  }

  Widget _buildPendingRequestInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Request sent to: ${widget.viewModel.pendingRequest!.receiverUsername}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _cancelRequest,
          child: _isLoading ? const CircularProgressIndicator() : const Text("Cancel"),
        ),
      ],
    );
  }

  Widget _buildCoachInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Coach Name: ${widget.viewModel.currentCoachName}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        // More coach details can be added here
      ],
    );
  }

  void _sendRequest() async {
    _setLoading(true);
    var message = await widget.viewModel.sendRequestToCoach(_requestController.text);
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
    setState(() {
      _isLoading = bool;
    });
  }

  void _onViewModelUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showSnackBar(String message) {
   if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
