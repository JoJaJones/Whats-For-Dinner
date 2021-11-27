import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:whats_for_dinner/controllers/RecipeController.dart';
import 'package:whats_for_dinner/screens/recipe_detail.dart';

import '../models/Recipe.dart';

class PlannerScreen extends StatefulWidget {
  static const String id = 'planner_screen';
  @override
  PlannerScreenPageState createState() => PlannerScreenPageState();
}

class PlannerScreenPageState extends State<PlannerScreen> {
  List<Recipe> recipes = [];
  String query = '';
  Timer? debouncer;
  final Map<int, bool> favoritedRecipes = {};

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Sun'),
    Tab(text: 'Mon'),
    Tab(text: 'Tue'),
    Tab(text: 'Wed'),
    Tab(text: 'Thu'),
    Tab(text: 'Fri'),
    Tab(text: 'Sat'),
  ];

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

  Widget buildRecipeList() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          final recipe = recipes[index];
          return buildRecipe(recipe);
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: tabs,
              ),
            ),
            body: TabBarView(children: [
              buildRecipeList(),
              buildRecipeList(),
              buildRecipeList(),
              buildRecipeList(),
              buildRecipeList(),
              buildRecipeList(),
              buildRecipeList(),
            ]));
      }),
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

  Widget buildRecipe(Recipe recipe) {
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
