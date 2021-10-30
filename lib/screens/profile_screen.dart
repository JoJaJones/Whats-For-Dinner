import 'package:flutter/cupertino.dart';
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
              maxCrossAxisExtent: 150.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          horizontalTitleGap: 5,
                          trailing: IconButton(
                            padding: const EdgeInsets.all(4),
                            splashRadius: 15,
                            iconSize: 15,
                            // alignment: Alignment.topRight,
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              // TODO remove recipe from favorite
                            },
                          ),
                          title: Text(
                            'Recipe Title',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=780&q=80',
                          ),
                        ),
                      )
                    ],
                  ),
                );
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
