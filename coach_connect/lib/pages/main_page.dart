import 'package:flutter/material.dart';
import 'package:coach_connect/models/user_account.dart';
import 'package:coach_connect/service/auth.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:coach_connect/utils/constants.dart';
import 'login_page.dart';
import 'client/client_home_page.dart';
import 'coach/coach_home_page.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final AuthenticationService _auth = AuthenticationService();

  // Define the orange and black theme
  final ThemeData orangeBlackTheme = ThemeData(
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
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges,
      builder: (context, AsyncSnapshot<dynamic> authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.active) {
          if (authSnapshot.data != null) {
            return FutureBuilder<UserAccount>(
              future: _auth.getCurrentUserAccountObject(),
              builder: (context, AsyncSnapshot<UserAccount> accountSnapshot) {
                if (accountSnapshot.connectionState == ConnectionState.done) {
                  if (accountSnapshot.hasData) {
                    final accountType = accountSnapshot.data!.accountType;
                    if (accountType == AccountType.client) {
                      return Theme(
                        data: orangeBlackTheme,
                        child: ClientHomePage(viewModel: ClientHomeViewModel(accountSnapshot.data!)),
                      );
                    } else if (accountType == AccountType.coach) {
                      return Theme(
                        data: orangeBlackTheme,
                        child: CoachHomePage(viewModel: CoachHomeViewModel(accountSnapshot.data!)),
                      );
                    } else {
                      _auth.signOut();
                      return _buildErrorWidget(context);
                    }
                  } else {
                    _auth.signOut();
                    return _buildErrorWidget(context);
                  }
                } else if (accountSnapshot.connectionState == ConnectionState.waiting) {
                  return Theme(
                    data: orangeBlackTheme,
                    child: const Scaffold(body: Center(child: CircularProgressIndicator())),
                  );
                } else {
                  return const LoginPage();
                }
              },
            );
          } else {
            return const LoginPage();
          }
        } else {
          return Theme(
            data: orangeBlackTheme,
            child: const Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return const Center(
      child: Text(
          'There has been some problem fetching your account details. Please reach support.'),
    );
  }
}
