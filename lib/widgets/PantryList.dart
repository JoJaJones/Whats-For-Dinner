import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/widgets/PantryListItem.dart';

class PantryList extends StatefulWidget {
  var refresh;

  PantryList(this.refresh);

  @override
  State<PantryList> createState() => _PantryListState();
}

class _PantryListState extends State<PantryList> {
  var data = PantryManager();

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) =>
              PantryListItem(data.ingredients[index], index, widget.refresh),

      ),
      padding: EdgeInsets.only(bottom: 6.0),
    );
  }
}
