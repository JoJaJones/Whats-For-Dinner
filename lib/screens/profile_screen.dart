import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/UserController.dart';
import 'package:whats_for_dinner/widgets/ProfileWidget.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = UserManager();
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              buildProfileList(user),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        child: Text(
                          'Favorite $index',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ));
              },
              childCount: 20,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildProfileList(UserManager user) => [
        // physics: BouncingScrollPhysics(),
        ProfileWidget(
          imagePath: user.imagePath,
          onClicked: () async {},
        ),
        const SizedBox(height: 24),
        buildName(user),
        const SizedBox(height: 24),
      ];

  Widget buildName(UserManager user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );
}
