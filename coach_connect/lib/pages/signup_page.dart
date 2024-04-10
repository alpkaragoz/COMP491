import 'package:coach_connect/utils/constants.dart';
import 'package:coach_connect/view_models/signup_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/init/languages/locale_keys.g.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SignupViewModel _viewModel = SignupViewModel();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

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
              controller: _emailController,
              decoration: InputDecoration(labelText: LocaleKeys.email.tr()),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: LocaleKeys.password.tr()),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: LocaleKeys.name.tr()),
            ),
            TextField(
              controller: _ageController,
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
              leading: Radio<AccountType>(
                value: AccountType.client,
                groupValue: _viewModel.accountType,
                onChanged: (AccountType? value) {
                  setState(() {
                    _viewModel.accountType = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.coach.tr()),
              leading: Radio<AccountType>(
                value: AccountType.coach,
                groupValue: _viewModel.accountType,
                onChanged: (AccountType? value) {
                  setState(() {
                    _viewModel.accountType = value!;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: _viewModel.isLoading ? null : _signup,
              child: _viewModel.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(LocaleKeys.signup.tr()),
            ),
          ],
        ),
      ),
    );
  }

  void _signup() async {
    bool signupResult = await _viewModel.signup(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        int.tryParse(_ageController.text) ?? 0);
    if (signupResult) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
    _showSnackBar(_viewModel.result.$2);
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelUpdated);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelUpdated);
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onViewModelUpdated() {
    if (mounted) {
      setState(() {});
    }
  }
}
