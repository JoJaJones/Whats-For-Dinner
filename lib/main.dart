import 'package:flutter/material.dart';
import 'package:whats_for_dinner/nav.dart';
import 'package:whats_for_dinner/screens/login_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  static final routes = {};
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What\'s for Dinner?',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        Nav.id: (context) => Nav(),
      },
    );
  }
}
