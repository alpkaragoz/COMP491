import 'package:coach_connect/init/languages/locale_keys.g.dart';
import 'package:coach_connect/init/languages/locales.dart';
import 'package:coach_connect/init/languages/product_localization.dart';
import 'package:coach_connect/mvvm/observer.dart';
import 'package:coach_connect/pages/client_home_page.dart';
import 'package:coach_connect/pages/coach_selection_page.dart';
import 'package:coach_connect/service/auth.dart';
import 'package:coach_connect/view_models/login_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements EventObserver {
  final _viewModel = LoginViewModel();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.login.tr()),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _viewModel.usernameController,
                decoration:
                    InputDecoration(labelText: LocaleKeys.username.tr()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _viewModel.passwordController,
                decoration:
                    InputDecoration(labelText: LocaleKeys.password.tr()),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(LocaleKeys.login.tr()),
                ),
              ),
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
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (context.locale == Locales.tr.locale) {
                            ProductLocalizations.updateLanguage(
                                context: context, value: Locales.en);
                          } else {
                            ProductLocalizations.updateLanguage(
                                context: context, value: Locales.tr);
                          }
                        });
                      },
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

  void _login() async {
    setState(() {
    _isLoading = true; // Start loading
    });
    final coachList = await getCoaches();
    final id = await _viewModel.login();
    if (id != null) {
      final clientModel = await getClient(id: id.toString());
      if (clientModel?.coach == null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CoachSelection(coachList: coachList!, clientId: id.toString(),)));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ClientHomePage()));
      }
    }
    setState(() {
      _isLoading = false; // Stop loading after the request is complete
    });
    _showSnackBar(_viewModel.returnMessage);
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
