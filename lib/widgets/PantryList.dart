import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/widgets/PantryListItem.dart';

class PantryList extends StatelessWidget {
  var data = PantryManager();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.size,
        itemBuilder: (context, index) =>
            PantryListItem(data.ingredients[index], index)
    );
  }
}
