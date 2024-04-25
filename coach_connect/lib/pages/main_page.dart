import 'package:coach_connect/models/user_account.dart';
import 'package:coach_connect/view_models/client/client_home_viewmodel.dart';
import 'package:coach_connect/view_models/coach/coach_home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:coach_connect/service/auth.dart';
import 'login_page.dart';
import 'client/client_home_page.dart';
import 'coach/coach_home_page.dart';
import 'package:coach_connect/utils/constants.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges, // Auth state changes stream
      builder: (context, AsyncSnapshot<dynamic> authSnapshot) {
        // Check the connection state and user data
        if (authSnapshot.connectionState == ConnectionState.active) {
          if (authSnapshot.data != null) {
            // User is signed in, get the account
            return FutureBuilder<UserAccount>(
              future: _auth.getCurrentUserAccountObject(), // Fetch the account
              builder: (context, AsyncSnapshot<UserAccount> accountSnapshot) {
                if (accountSnapshot.connectionState == ConnectionState.done) {
                  if (accountSnapshot.hasData) {
                    // Data is non-null, safe to access accountType
                    final accountType = accountSnapshot.data!.accountType;
                    if (accountType == AccountType.client) {
                      return ClientHomePage(
                        viewModel: ClientHomeViewModel(accountSnapshot
                            .data!), // Data is non-null, safe to access accountType
                      );
                    } else if (accountType == AccountType.coach) {
                      return CoachHomePage(
                          viewModel: CoachHomeViewModel(accountSnapshot.data!));
                    } else {
                      // Error
                      _auth.signOut();
                      return _buildErrorWidget(context);
                    }
                  } else {
                    // No data is available
                    _auth.signOut();
                    return _buildErrorWidget(context);
                  }
                } else if (accountSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  // The Future is still working, show a loading spinner
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  // In case none of the above conditions are met, provide a default Widget
                  return const LoginPage();
                }
              },
            );
          } else {
            // User is not signed in, show the login page
            return const LoginPage();
          }
        } else {
          // Connection to auth state stream is still loading
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    // Log the error or show a dialog before returning a Widget
    return const Center(
      child: Text(
          'There has been some problem fetching your account details. Please reach support.'),
    );
  }
}
