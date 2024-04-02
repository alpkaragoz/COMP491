import 'package:coach_connect/mvvm/observer.dart';
import 'package:coach_connect/view_models/signup_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/init/languages/locale_keys.g.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> implements EventObserver {
  final SignupViewModel _viewModel = SignupViewModel();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.signup.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context)
              .pop(), // This takes the user back to the previous screen
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _viewModel.emailController,
              decoration: InputDecoration(labelText: LocaleKeys.email.tr()),
            ),
            TextField(
              controller: _viewModel.passwordController,
              decoration: InputDecoration(labelText: LocaleKeys.password.tr()),
              obscureText: true,
            ),
            TextField(
              controller: _viewModel.nameController,
              decoration: InputDecoration(labelText: LocaleKeys.name.tr()),
            ),
            TextField(
              controller: _viewModel.ageController,
              decoration: InputDecoration(labelText: LocaleKeys.age.tr()),
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                LocaleKeys.signupAccountTypePrompt.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.client.tr()),
              leading: Radio<String>(
                value: 'client',
                groupValue: _viewModel.accountType,
                onChanged: (String? value) {
                  setState(() {
                    _viewModel.accountType = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.coach.tr()),
              leading: Radio<String>(
                value: 'coach',
                groupValue: _viewModel.accountType,
                onChanged: (String? value) {
                  setState(() {
                    _viewModel.accountType = value!;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true; // Start loading
                });
                await _viewModel.signup();
                setState(() {
                  _isLoading =
                      false; // Stop loading after the request is complete
                });
                _showSnackBar(_viewModel.returnMessage);
              },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(LocaleKeys.signup.tr()),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.unsubscribe(this);
  }

  @override
  void notify(ViewEvent event) {}
}
