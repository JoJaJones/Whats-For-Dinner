import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:whats_for_dinner/controllers/RecipeController.dart';
import 'package:whats_for_dinner/screens/recipe_detail.dart';
import 'package:whats_for_dinner/widgets/SearchWidget.dart';
import 'package:whats_for_dinner/nav.dart';
import '../models/Recipe.dart';

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

  Map filters = {
    "Chinese": false,
    "Italian": false,
    "Mexican": false,
    "Vegetarian": false,
    "Vegan": false,
    "PantryOnly": false,
  };

  final Map<int, bool> favoritedRecipes = {};

  @override
  void initState() {
    super.initState();
    init();
    loadList();
  }

  loadAllSaved() {
    if (filters["PantryOnly"]) {
      setState(() => this.recipes = RecipeController.pantryRecipes);
    } else {
      setState(() => this.recipes = RecipeController.allRecipes);
    }
  }

  Future loadList() async {
    List<Recipe> grabbedList = [];
    Future.delayed(Duration(seconds: 2), () async {
      print("PantryOnly is currently ${filters["PantryOnly"]}");
      keyRefresh.currentState?.show();
      if (filters["PantryOnly"]) {
        grabbedList = await RecipeController.getAllPantryRecipes();
      } else {
        grabbedList = await RecipeController.getAllRecipes();
      }
      var recipes = grabbedList;
      setState(() => this.recipes = recipes);
    });
  }

  Future init() async {
    Future.delayed(
      Duration(seconds: 5),
      () {
        searchRecipes("");
      },
    );
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
        title: Column(
          children: <Widget>[
            buildSearch(),
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text("Filter Recipes"),
                          content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Pantry Only"),
                                    Checkbox(
                                        checkColor: Colors.white,
                                        value: filters["PantryOnly"],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            filters["PantryOnly"] = value!;
                                          });
                                        }),
                                  ],
                                ),
                              ]),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  loadList();
                                });
                                Navigator.pop(context);
                              },
                              child: Text("Save"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              })
        ],
      ),
      body: StreamBuilder(builder: (context, projectSnap) {
        return RefreshIndicator(
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
                  loadAllSaved();
                });
              },
            );
          },
        );
      }));

  Future searchRecipes(String query) async => debounce(() async {
        final recipes = await RecipeController.searchRecipes(query,
            pantry: filters["PantryOnly"]);
        setState(() {
          this.query = query;
          this.recipes = recipes;
        });
      });

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search recipes..',
        onChanged: searchRecipes,
      );

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
              onPressed: () async {
                setState(() {
                  recipe.favorited = recipe.favorited
                      ? recipe.favorited = false
                      : recipe.favorited = true;
                });
                if (recipe.favorited) {
                  try {
                    //TODO: Move into a favorites manager
                    //Note: App needs to refresh for this to show up in profile
                    await RecipeController.addRecipesToUserCollection(
                        recipe.id.toString(), "Favorites");
                    // Restart.restartApp();
                  } catch (e) {
                    print(e);
                  }
                } else {
                  try {
                    //TODO: Move into a favorites manager
                    //Note: App needs to refresh for this to update in profile
                    await RecipeController.deleteRecipeFromUserCollection(
                        recipe.id.toString(), "Favorites");
                  } catch (e) {
                    print(e);
                  }
                }
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
