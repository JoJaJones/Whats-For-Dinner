import 'package:flutter/material.dart';
import 'package:whats_for_dinner/nav.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  static final routes = {

  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What\'s for dinner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Nav(),
    );
  }
}

