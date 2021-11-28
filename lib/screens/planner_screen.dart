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
  List<Recipe> sunRecipes = [];
  List<Recipe> monRecipes = [];
  List<Recipe> tuesRecipes = [];
  List<Recipe> wedRecipes = [];
  List<Recipe> thursRecipes = [];
  List<Recipe> friRecipes = [];
  List<Recipe> satRecipes = [];
  static const String Sun = "Sunday";
  static const String Mon = "Monday";
  static const String Tues = "Tuesday";
  static const String Wed = "Wednesday";
  static const String Thurs = "Thursday";
  static const String Fri = "Friday";
  static const String Sat = "Saturday";
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
    final sunRecipes =
        await RecipeController.loadRecipesFromUserCollection(Sun);
    final monRecipes =
        await RecipeController.loadRecipesFromUserCollection(Mon);
    final tuesRecipes =
        await RecipeController.loadRecipesFromUserCollection(Tues);
    final wedRecipes =
        await RecipeController.loadRecipesFromUserCollection(Wed);
    final thursRecipes =
        await RecipeController.loadRecipesFromUserCollection(Thurs);
    final friRecipes =
        await RecipeController.loadRecipesFromUserCollection(Fri);
    final satRecipes =
        await RecipeController.loadRecipesFromUserCollection(Sat);

    setState(() {
      this.sunRecipes = sunRecipes;
      this.monRecipes = monRecipes;
      this.tuesRecipes = tuesRecipes;
      this.wedRecipes = wedRecipes;
      this.thursRecipes = thursRecipes;
      this.friRecipes = friRecipes;
      this.satRecipes = satRecipes;
    });
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

  Widget buildRecipeList(List<Recipe> recipes, String day) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          final recipe = recipes[index];
          return buildRecipe(recipe, day);
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
              buildRecipeList(sunRecipes, Sun),
              buildRecipeList(monRecipes, Mon),
              buildRecipeList(tuesRecipes, Tues),
              buildRecipeList(wedRecipes, Wed),
              buildRecipeList(thursRecipes, Thurs),
              buildRecipeList(friRecipes, Fri),
              buildRecipeList(satRecipes, Sat),
            ]));
      }),
    );
  }

  Widget buildRecipe(Recipe recipe, String day) {
    return Card(
      child: ExpansionTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_outlined,
                  size: 25.0, color: Colors.redAccent),
              onPressed: () async {
                //TODO: Move to a Meal Planner manager
                await deleteRecipe(recipe.id.toString(), day);
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

  Future deleteRecipe(String recipeID, String day) async => debounce(() async {
        await RecipeController.deleteRecipeFromUserCollection(recipeID, day);
        await updateDaysRecipes(day);
      });

  Future updateDaysRecipes(String day) async => debounce(() async {
        List<Recipe> tempRecipes =
            await RecipeController.loadRecipesFromUserCollection(day);
        switch (day) {
          case Sun:
            setState(() {
              this.sunRecipes = tempRecipes;
            });
            break;
          case Mon:
            setState(() {
              this.monRecipes = tempRecipes;
            });
            break;
          case Tues:
            setState(() {
              this.tuesRecipes = tempRecipes;
            });
            break;
          case Wed:
            setState(() {
              this.wedRecipes = tempRecipes;
            });
            break;
          case Thurs:
            setState(() {
              this.thursRecipes = tempRecipes;
            });
            break;
          case Fri:
            setState(() {
              this.friRecipes = tempRecipes;
            });
            break;
          case Sat:
            setState(() {
              this.satRecipes = tempRecipes;
            });
            break;
        }
      });
}
