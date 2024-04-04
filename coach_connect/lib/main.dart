import 'package:coach_connect/init/languages/product_localization.dart';
import 'package:coach_connect/pages/home_navigator_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:coach_connect/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'service/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();
  runApp(ProductLocalizations(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: LoginPage()/* StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return const LoginPage();
            }
            return const HomePageNavigator();
          }
          // Return a loading indicator while waiting for the auth state to initialize
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ), */
    );
  }
}
