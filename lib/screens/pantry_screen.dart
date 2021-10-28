import 'package:flutter/material.dart';
import 'package:whats_for_dinner/screens/AddIngredientScreen.dart';

class PantryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            AddIngredientScreen.routeName
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}