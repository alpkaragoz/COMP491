import 'package:flutter/material.dart';
import 'package:coach_connect/pages/client_home_page.dart';
import 'package:coach_connect/pages/coach_home_page.dart';
import 'package:coach_connect/view_models/home_navigator_viewmodel.dart';

class HomeNavigatorPage extends StatefulWidget {
  const HomeNavigatorPage({super.key});

  @override
  State<HomeNavigatorPage> createState() => _HomeNavigatorPageState();
}

class _HomeNavigatorPageState extends State<HomeNavigatorPage> {
  final HomeNavigatorViewModel _viewModel = HomeNavigatorViewModel();

  @override
  Widget build(BuildContext context) {
    if (_viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_viewModel.errorMessage != null) {
      return Scaffold(
        body: Center(
            child: Text("Error fetching user: ${_viewModel.errorMessage}")),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _viewModel.signOut();
          },
          child: const Icon(Icons.exit_to_app),
        ),
      );
    }
    if (_viewModel.user == null) {
      return Scaffold(
        body: const Center(child: Text("User not found")),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _viewModel.signOut();
          },
          child: const Icon(Icons.exit_to_app),
        ),
      );
    }
    return _viewModel.user!.accountType == 'coach'
        ? const CoachHomePage()
        : const ClientHomePage();
  }

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelUpdated);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelUpdated);
    super.dispose();
  }

  void _onViewModelUpdated() {
    // This function will be called whenever the ViewModel calls notifyListeners().
    setState(() {});
  }
}
