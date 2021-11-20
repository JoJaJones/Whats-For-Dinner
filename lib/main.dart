import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/nav.dart';
import 'package:whats_for_dinner/screens/AddIngredientScreen.dart';
import 'package:whats_for_dinner/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  String initRoute = LoginScreen.id;

  @override
  Widget build(BuildContext context) {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        initRoute = Nav.id;
      }
    } catch (e) {
      print(e);
    }

    return MaterialApp(
      title: 'What\'s for Dinner?',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: initRoute,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        Nav.id: (context) => Nav(),
        AddIngredientScreen.routeName: (context) => AddIngredientScreen(),
      },
    );
  }
}
