import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'landing_page.dart';
import 'cgpa_provider.dart';
import 'login_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CGPAProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()), // Add this line
      ],
      child: GpaCalculatorApp(),
    ),
  );
}

class GpaCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<LoginProvider>(
        builder: (context, loginProvider, _) {
          // Check if the user is logged in
          if (loginProvider.isLoggedIn) {
            return HomePage();
          } else {
            return LandingPage();
          }
        },
      ),
    );
  }
}
