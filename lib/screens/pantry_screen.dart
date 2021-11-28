import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/screens/AddIngredientScreen.dart';
import 'package:whats_for_dinner/widgets/PantryList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantryScreen extends StatefulWidget {
  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  PantryManager data = PantryManager();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
              AddIngredientScreen.routeName
          ).then((value) {
            setState(() {

            });
          });
        },
        child: Icon(Icons.add),
      ),
      body: PantryList(refresh),
    );
  }

  void refresh(){
    setState(() {

    });
  }
}