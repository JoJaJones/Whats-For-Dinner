import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/nav.dart';
import 'package:whats_for_dinner/screens/AddIngredientScreen.dart';
import 'package:whats_for_dinner/screens/edit_profile_screen.dart';
import 'package:whats_for_dinner/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
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
        EditProfileScreen.id: (context) => EditProfileScreen(),
        AddIngredientScreen.routeName: (context) => AddIngredientScreen(),
      },
    );
  }
}
