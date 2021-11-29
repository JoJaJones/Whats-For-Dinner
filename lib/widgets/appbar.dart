import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/FirestoreController.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/screens/login_screen.dart';

import 'components/SimpleComponents.dart';

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

final _auth = FirebaseAuth.instance;
AppBar buildRefreshBar(BuildContext context, var refresh) {
  return AppBar(
    title: TitleText("What's for Dinner?"),
    actions: [
      refreshButton(context, refresh),
      signoutButton(context)
    ],
    automaticallyImplyLeading: false,
  );
}

AppBar buildMultiActionAppBar(BuildContext context, List<IconButton> actions){
  return AppBar(
    title: TitleText("What's for Dinner?"),
    actions: actions,
    automaticallyImplyLeading: false,
  );
}

IconButton refreshButton(BuildContext context, var refresh) {
  return IconButton(
      onPressed: refresh,
      icon: Icon(Icons.autorenew)
  );
}

IconButton signoutButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      PantryManager().clear();
      FirestoreController().resetUser();
      Navigator.pushNamed(context, LoginScreen.id);
    },
    icon: Icon(Icons.logout)
  );
}