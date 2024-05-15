import 'package:coach_connect/init/languages/locale_keys.g.dart';
import 'package:coach_connect/init/languages/locales.dart';
import 'package:coach_connect/init/languages/product_localization.dart';
import 'package:coach_connect/view_models/login_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _viewModel = LoginViewModel();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.login.tr(),
          style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      ),
      backgroundColor: const Color.fromARGB(255, 28, 40, 44),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Add the logo image here
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Image.asset(
                  'assets/cclogo.png',
                  height: 200, // Adjust the height as needed
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.email.tr(),
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 56, 80, 88),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: LocaleKeys.password.tr(),
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 56, 80, 88),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _viewModel.isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                  backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: _viewModel.isLoading
                    ? const CircularProgressIndicator(color: Color.fromARGB(255, 226, 182, 167))
                    : Text(
                        LocaleKeys.login.tr(),
                        style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                      ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: Text(
                  LocaleKeys.signupPrompt.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color.fromARGB(255, 226, 182, 167)),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _toggleLanguage,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 226, 182, 167),
                        backgroundColor: const Color.fromARGB(255, 56, 80, 88),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('TR/EN'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleLanguage() {
    setState(() {
      if (context.locale == Locales.tr.locale) {
        ProductLocalizations.updateLanguage(
            context: context, value: Locales.en);
      } else {
        ProductLocalizations.updateLanguage(
            context: context, value: Locales.tr);
      }
    });
  }

  void _login() async {
    final result =
        await _viewModel.login(_emailController.text, _passwordController.text);
    _showSnackBar(result.$2);
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
    super.dispose();
  }

  void _onViewModelUpdated() {
    if (mounted) {
      setState(() {});
    }
  }
}
