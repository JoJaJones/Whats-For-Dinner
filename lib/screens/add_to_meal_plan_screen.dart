import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/RecipeController.dart';
import 'package:whats_for_dinner/models/Recipe.dart';

class AddToMealPlanScreen extends StatelessWidget {
  final Recipe recipe;
  final AddMealPlanTile sunday =
      AddMealPlanTile(day: "Sunday", isChecked: false);
  final AddMealPlanTile monday =
      AddMealPlanTile(day: "Monday", isChecked: false);
  final AddMealPlanTile tuesday =
      AddMealPlanTile(day: "Tuesday", isChecked: false);
  final AddMealPlanTile wednesday =
      AddMealPlanTile(day: "Wednesday", isChecked: false);
  final AddMealPlanTile thursday =
      AddMealPlanTile(day: "Thursday", isChecked: false);
  final AddMealPlanTile friday =
      AddMealPlanTile(day: "Friday", isChecked: false);
  final AddMealPlanTile saturday =
      AddMealPlanTile(day: "Saturday", isChecked: false);
  AddToMealPlanScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      children: [
        const SizedBox(height: 30),
        Text(
          "Add recipe to which days?",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        sunday,
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Material(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            elevation: 5.0,
            child: MaterialButton(
              onPressed: () async {
                final List<AddMealPlanTile> week = [
                  this.sunday,
                  this.monday,
                  this.tuesday,
                  this.wednesday,
                  this.thursday,
                  this.friday,
                  this.saturday
                ];

                for (AddMealPlanTile day in week) {
                  if (day.dayIsChecked) {
                    print("Adding to the ${day.day} collection");
                    // TODO Add to Planner Manager
                    RecipeController.addRecipesToUserCollection(
                        recipe.id.toString(), "${day.day}");
                  }
                }
                Navigator.of(context).pop();
              },
              minWidth: 200.0,
              height: 42.0,
              child: Text(
                'Submit',
              ),
            ),
          ),
        ),
      ],
    ));
  }
}

/// This is the stateful widget that the main application instantiates.
class AddMealPlanTile extends StatefulWidget {
  final String day;
  bool isChecked = false;
  AddMealPlanTile({Key? key, required this.day, required this.isChecked})
      : super(key: key);

  @override
  State<AddMealPlanTile> createState() => _AddMealPlanTileState();

  bool get dayIsChecked => isChecked;
  set dayIsChecked(bool value) {
    isChecked = value;
  }
}

/// This is the private State class that goes with MyStatefulWidget.
class _AddMealPlanTileState extends State<AddMealPlanTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.day),
      value: widget.dayIsChecked,
      onChanged: (bool? value) {
        setState(() {
          print("I was called for ${widget.day}");
          widget.dayIsChecked = value!;
          print("Value is ${widget.dayIsChecked}");
        });
      },
      secondary: const Icon(Icons.calendar_today_outlined),
    );
  }
}
