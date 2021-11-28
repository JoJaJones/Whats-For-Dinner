import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/FirestoreController.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/screens/login_screen.dart';

AppBar buildAppBar(BuildContext context) {
  final _auth = FirebaseAuth.instance;
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
          onPressed: () {
            _auth.signOut();
            PantryManager().clear();
            FirestoreController().resetUser();
            Navigator.pushNamed(context, LoginScreen.id);
          },
          icon: Icon(Icons.logout))
    ],
  );
}
