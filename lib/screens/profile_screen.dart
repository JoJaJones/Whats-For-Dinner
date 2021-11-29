import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/FirestoreController.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/controllers/RecipeController.dart';
import 'package:whats_for_dinner/screens/edit_profile_screen.dart';
import 'package:whats_for_dinner/screens/recipe_detail.dart';
import 'package:whats_for_dinner/widgets/ProfileWidget.dart';
import 'package:whats_for_dinner/widgets/appbar.dart';

import '../models/Recipe.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  @override
  ProfileScreenPageState createState() => ProfileScreenPageState();
}

class ProfileScreenPageState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  static const String DEFAULT_PROFILE_IMAGE =
      "https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1387&q=80";
  List<Recipe> recipes = [];
  Timer? debouncer;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    //TODO: Move into a favorites manager
    recipes = await RecipeController.loadRecipesFromUserCollection("Favorites");

    setState(() => this.recipes = recipes);
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      appBar: buildRefreshBar(context, refresh),
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
                onPressed: () async {
                  try {
                    //TODO: Move into a favorites manager
                    await deleteRecipe(recipe.id.toString());
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              title: Text(
                recipe.title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailView(recipe: recipe),
                  ),
                );
              },
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

  Future deleteRecipe(String recipeID) async => debounce(() async {
        RecipeController.deleteRecipeFromUserCollection(recipeID, "Favorites");

        recipes =
            await RecipeController.loadRecipesFromUserCollection("Favorites");

        setState(() {
          this.recipes = recipes;
        });
      });

  List<Widget> buildProfileList(BuildContext context, User? user) {
    String image;

    if (user == null || user.photoURL == null) {
      image = DEFAULT_PROFILE_IMAGE;
    } else {
      image = user.photoURL!;
    }

    return [
      ProfileWidget(
        imagePath: image,
        onClicked: () async {
          Navigator.pushNamed(context, EditProfileScreen.id)
              .then((_) => setState(() {}));
        },
      ),
      const SizedBox(height: 24),
      buildName(user),
      const SizedBox(height: 24),
    ];
  }

  Widget buildName(User? user) {
    String name;
    String email;

    if (user == null || user.displayName == null) {
      name = "tap image to edit your profile!";
    } else {
      name = user.displayName!;
    }

    if (user == null || user.email == null) {
      email = "ERROR: email not found";
    } else {
      email = user.email!;
    }

    return Column(
      children: [
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  void refresh(){
    setState(() {

    });
  }
}
