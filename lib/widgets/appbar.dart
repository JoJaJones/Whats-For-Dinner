import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            Navigator.pushNamed(context, LoginScreen.id);
          },
          icon: Icon(Icons.logout))
    ],
  );
}
