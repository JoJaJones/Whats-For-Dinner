import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:whats_for_dinner/models/Recipe.dart';
import 'package:whats_for_dinner/screens/add_to_meal_plan_screen.dart';

class RecipeDetailView extends StatelessWidget {
  final Recipe recipe;
  RecipeDetailView({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          title: Text(recipe.title),
          backgroundColor: Colors.green,
          expandedHeight: 350.0,
          flexibleSpace: FlexibleSpaceBar(
              background: Image.network(recipe.image, fit: BoxFit.cover))),
      SliverList(
          delegate: SliverChildListDelegate([
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(recipe.title,
                style: TextStyle(fontSize: 30, color: Colors.green[900]))),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                child: Column(children: [
              Row(children: [
                recipe.dairyFree
                    ? Text.rich(
                        TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: <InlineSpan>[
                            WidgetSpan(
                              child: Icon(Icons.local_drink),
                            ),
                            const TextSpan(
                              text: 'Dairy Free',
                            ),
                          ],
                        ),
                      )
                    : Text.rich(
                        TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: <InlineSpan>[
                            WidgetSpan(
                              child: Icon(Icons.local_drink),
                            ),
                            const TextSpan(
                              text: 'Not Dairy Free',
                            ),
                          ],
                        ),
                      ),
                recipe.vegan
                    ? Text.rich(
                        TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: <InlineSpan>[
                            WidgetSpan(
                              child: Icon(Icons.pets_outlined),
                            ),
                            const TextSpan(
                              text: 'Vegan Friendly',
                            ),
                          ],
                        ),
                      )
                    : Text.rich(
                        TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: <InlineSpan>[
                            WidgetSpan(
                              child: Icon(Icons.pets_outlined),
                            ),
                            const TextSpan(
                              text: 'Not Vegan Friendly',
                            ),
                          ],
                        ),
                      ),
                recipe.vegetarian
                    ? Text.rich(
                        TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: <InlineSpan>[
                            WidgetSpan(
                              child: Icon(Icons.grass_outlined),
                            ),
                            const TextSpan(
                              text: 'Vegetarian',
                            ),
                          ],
                        ),
                      )
                    : Text.rich(
                        TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: <InlineSpan>[
                            WidgetSpan(
                              child: Icon(Icons.grass_outlined),
                            ),
                            const TextSpan(
                              text: 'Not Vegetarian',
                            ),
                          ],
                        ),
                      ),
                /*
                Icon(Icons.grass_outlined),
                Icon(Icons.local_drink),
                Icon(Icons.pets_outlined)
                */
              ]),
              SizedBox(height: 16.0),
            ]))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Html(data: recipe.summary),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Html(data: recipe.instructions),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Material(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            elevation: 5.0,
            child: MaterialButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddToMealPlanScreen(recipe: recipe),
                  ),
                );
              },
              minWidth: 200.0,
              height: 42.0,
              child: Text(
                'Add To Meal Plan',
              ),
            ),
          ),
        ),
      ]))
    ])));
  }
}
