import 'package:flutter/material.dart';
import 'dart:async';
import '../models/Recipe.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:whats_for_dinner/screens/recipe_detail.dart';
import 'package:whats_for_dinner/controllers/RecipeController.dart';
import 'package:whats_for_dinner/controllers/FirestoreController.dart';

class SearchScreen extends StatefulWidget {
  @override
  RecipeSearchPageState createState() => RecipeSearchPageState();
}

class RecipeSearchPageState extends State<SearchScreen> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  List<Recipe> recipes = [];
  String query = '';
  Timer? debouncer;
  bool isLoading = false;

  final Map<int, bool> favoritedRecipes = {};

  @override
  void initState() {
    super.initState();
    init();
    loadList();
  }

  Future loadList() async {
    keyRefresh.currentState?.show();
    await Future.delayed(Duration(milliseconds: 4000));
    final recipes = await RecipeController.getAllRecipes();
    setState(() => this.recipes = recipes);
  }

  Future init() async {}

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextField(
          autofocus: true,
          //controller: _searchQuery,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(end: 16.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
              hintText: "Search Recipes...",
              hintStyle: TextStyle(color: Colors.white60)),
          onChanged: searchRecipes,
        ),
        automaticallyImplyLeading: false,
      ),
      body: //Padding(
          RefreshIndicator(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: recipes.length,
          itemBuilder: (BuildContext context, int index) {
            final recipe = recipes[index];
            return buildRecipe(recipe, index);
          },
          // To make listView scrollable
          // even if there is only a single item.
          physics: const AlwaysScrollableScrollPhysics(),
        ),
        // Function that will be called when
        // user pulls the ListView downward
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
            () {
              setState(() {
                loadList();
              });
            },
          );
        },
      ));

  Future searchRecipes(String query) async => debounce(() async {
        final recipes = await RecipeController.searchRecipes(query);

        setState(() {
          this.query = query;
          this.recipes = recipes;
        });
      });

  Widget buildRecipe(Recipe recipe, index) {
    return Card(
      child: ExpansionTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.favorite_border,
                  size: 20.0,
                  color: recipe.favorited ? Colors.redAccent : Colors.brown),
              onPressed: () {
                setState(() {
                  recipe.favorited = recipe.favorited
                      ? recipe.favorited = false
                      : recipe.favorited = true;
                });
              },
            ),
          ],
        ),
        leading: CircleAvatar(backgroundImage: NetworkImage(recipe.image)),
        title: Text(
          recipe.title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        children: <Widget>[
          ListTile(
            title: Html(data: recipe.summary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailView(recipe: recipe),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
