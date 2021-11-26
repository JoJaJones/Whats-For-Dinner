import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/RecipeController.dart';
import 'package:whats_for_dinner/controllers/UserController.dart';
import 'package:whats_for_dinner/screens/edit_profile_screen.dart';
import 'package:whats_for_dinner/widgets/ProfileWidget.dart';
import 'package:whats_for_dinner/widgets/appbar.dart';

import '../models/Recipe.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenPageState createState() => ProfileScreenPageState();
}

class ProfileScreenPageState extends State<ProfileScreen> {
  static const String id = 'profile_screen';
  List<Recipe> recipes = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final recipes = await RecipeController.getAllRecipes();

    setState(() => this.recipes = recipes);
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 4000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    final user = UserManager();
    return Scaffold(
      appBar: buildAppBar(context),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              buildProfileList(context, user),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return buildRecipe(index);
              },
              childCount: recipes.length,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildRecipeList(BuildContext context, int index) => [];

  Widget buildRecipe(int index) {
    final recipe = recipes[index];

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
                recipe.title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ClipOval(
              child: Material(
                child: Ink.image(
                  image: NetworkImage(recipe.image),
                  fit: BoxFit.cover,
                  width: 87, // in the future, shouldn't be hardcoded
                ),
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }

  Future searchRecipes(String query) async => debounce(() async {
        final recipes = await RecipeController.getAllRecipes();
        // TODO will need to update for however we store recipes a user puts into the meal plan
        setState(() {
          this.query = query;
          this.recipes = recipes;
        });
      });

  List<Widget> buildProfileList(BuildContext context, UserManager user) => [
        // physics: BouncingScrollPhysics(),
        ProfileWidget(
          imagePath: user.imagePath,
          onClicked: () async {
            Navigator.pushNamed(context, EditProfileScreen.id);
          },
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
