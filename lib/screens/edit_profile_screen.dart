import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/widgets/ProfileWidget.dart';

class EditProfileScreen extends StatelessWidget {
  static const String id = 'edit_profile_screen';
  static const String DEFAULT_PROFILE_IMAGE =
      "https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1387&q=80";
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        children: buildEditProfileList(context, user),
      ),
    );
  }

  List<Widget> buildEditProfileList(BuildContext context, User? user) {
    String image, name, email;
    bool imageChanged = false;
    bool nameChanged = false;
    bool emailChanged = false;

    if (user!.photoURL == null) {
      image = DEFAULT_PROFILE_IMAGE;
    } else {
      image = user.photoURL!;
    }
    if (user.displayName == null) {
      name = "Enter Your Name";
    } else {
      name = user.displayName!;
    }
    if (user.email == null) {
      email = "ERROR: email not found";
    } else {
      email = user.email!;
    }

    return [
      ProfileWidget(
        imagePath: image,
        isEdit: true,
        onClicked: () async {
          Navigator.pop(context);
        },
      ),
      const SizedBox(height: 24),
      Text(
        "Name",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextField(
        textAlign: TextAlign.center,
        onChanged: (value) {
          name = value;
          nameChanged = true;
        },
        decoration: InputDecoration(
          hintText: name,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      const SizedBox(height: 24),
      Text(
        "Email",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          email = value;
          emailChanged = true;
        },
        decoration: InputDecoration(
          hintText: email,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      const SizedBox(height: 24),
      Text(
        "Photo URL",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextField(
        textAlign: TextAlign.center,
        onChanged: (value) {
          image = value;
          imageChanged = true;
        },
        decoration: InputDecoration(
          hintText: image,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      SizedBox(
        height: 24.0,
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Material(
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          elevation: 5.0,
          child: MaterialButton(
            onPressed: () async {
              try {
                if (nameChanged) {
                  await user.updateDisplayName(name);
                }
                if (emailChanged) {
                  await user.updateEmail(email);
                }
                if (imageChanged) {
                  await user.updatePhotoURL(image);
                }
                Navigator.of(context).pop();
              } catch (e) {
                print(e);
              }
            },
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              'Submit',
            ),
          ),
        ),
      ),
    ];
  }
}
