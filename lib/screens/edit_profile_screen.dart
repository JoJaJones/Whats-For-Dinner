import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/UserController.dart';
import 'package:whats_for_dinner/widgets/ProfileWidget.dart';
import 'package:whats_for_dinner/widgets/textfield_widget.dart';

class EditProfileScreen extends StatelessWidget {
  static const String id = 'edit_profile_screen';
  @override
  Widget build(BuildContext context) {
    final user = UserManager();
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        children: buildEditProfileList(context, user),
      ),
    );
  }

  List<Widget> buildEditProfileList(BuildContext context, UserManager user) => [
        // physics: BouncingScrollPhysics(),
        ProfileWidget(
          imagePath: user.imagePath,
          isEdit: true,
          onClicked: () async {
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 24),
        TextFieldWidget(
          label: 'Name',
          text: user.name,
          onChanged: (name) {},
        ),
        const SizedBox(height: 24),
        TextFieldWidget(
          label: 'Email',
          text: user.email,
          onChanged: (email) {},
        ),
      ];
}
