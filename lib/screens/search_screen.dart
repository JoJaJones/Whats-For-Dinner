import 'package:flutter/material.dart';
import 'package:whats_for_dinner/api/recipes_api.dart';
import 'dart:async';
import '../models/Recipe.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:whats_for_dinner/screens/recipe_detail.dart';

class SearchScreen extends StatefulWidget {
  @override
  RecipeSearchPageState createState() => RecipeSearchPageState();
}

class RecipeSearchPageState extends State<SearchScreen> {
  List<Recipe> recipes = [];
  String query = '';
  Timer? debouncer;

  final Map<int, bool> favoritedRecipes = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final recipes = await RecipesApi.searchRecipes(query);

    setState(() => this.recipes = recipes);
  }

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: recipes.length,
            itemBuilder: (BuildContext context, int index) {
              final recipe = recipes[index];
              return buildRecipe(recipe, index);
            },
          ),
        ),
      );

  Future searchRecipes(String query) async => debounce(() async {
        final recipes = await RecipesApi.searchRecipes(query);

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
        leading: CircleAvatar(backgroundImage: NetworkImage(recipe.imageurl)),
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
