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
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.signup.tr(),
          style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 226, 182, 167)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: LocaleKeys.email.tr(),
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                filled: true,
                fillColor: const Color.fromARGB(255, 56, 80, 88),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: LocaleKeys.password.tr(),
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                filled: true,
                fillColor: const Color.fromARGB(255, 56, 80, 88),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: LocaleKeys.name.tr(),
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                filled: true,
                fillColor: const Color.fromARGB(255, 56, 80, 88),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: LocaleKeys.age.tr(),
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                filled: true,
                fillColor: const Color.fromARGB(255, 56, 80, 88),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                filled: true,
                fillColor: const Color.fromARGB(255, 56, 80, 88),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                LocaleKeys.signupAccountTypePrompt.tr(),
                style: TextStyle(
                  color: const Color.fromARGB(255, 226, 182, 167),
                  fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                ),
              ),
            ),
            ListTile(
              title: Text(
                LocaleKeys.client.tr(),
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
              leading: Radio<AccountType>(
                value: AccountType.client,
                groupValue: _viewModel.accountType,
                onChanged: (AccountType? value) {
                  setState(() {
                    _viewModel.accountType = value!;
                  });
                },
                fillColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ListTile(
              title: Text(
                LocaleKeys.coach.tr(),
                style:
                    const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
              ),
              leading: Radio<AccountType>(
                value: AccountType.coach,
                groupValue: _viewModel.accountType,
                onChanged: (AccountType? value) {
                  setState(() {
                    _viewModel.accountType = value!;
                  });
                },
                fillColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 226, 182, 167)),
              ),
            ),
            ElevatedButton(
              onPressed: _viewModel.isLoading ? null : _signup,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: _viewModel.isLoading
                  ? const CircularProgressIndicator(color: Color.fromARGB(255, 226, 182, 167))
                  : Text(
                      LocaleKeys.signup.tr(),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 226, 182, 167)),
                    ),
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
        int.tryParse(_ageController.text) ?? 0,
        _usernameController.text);
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
    _usernameController.dispose();
    super.dispose();
  }

  void _onViewModelUpdated() {
    if (mounted) {
      setState(() {});
    }
  }
}
