import 'package:flutter/material.dart';
import 'package:whats_for_dinner/models/IngredientType.dart';
import 'package:whats_for_dinner/widgets/components/SimpleComponents.dart';

class PantryListItem extends StatelessWidget {
  IngredientType curIngredient;
  int index;
  static const EXPIRY_ENABLED = true;

  PantryListItem(this.curIngredient, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: ListTile(
        title: TitleText(curIngredient.name),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: createDetails(),
        ),
        tileColor: Color(Colors.lightBlueAccent.value),
      ),
      padding: EdgeInsets.only(left: 6.0, right: 6.0, top: 6.0),
    );
  }

  List<Widget> createDetails(){
    var children = List<Widget>.empty(growable: true);
    children.add(
        ContentText("available: ${formatQuantity(curIngredient.quantity)}")
    );
    
    if(curIngredient.isPerishable && EXPIRY_ENABLED){
      children.add(
        ContentText("use by: ${curIngredient.earliestExpiration}")
      );
    }
    return children;
  }
  
  String formatQuantity(double quantity){
    if((quantity - quantity.round()).abs() < .001){
      return "${quantity.round()}";
    }
    
    return "${quantity.toStringAsFixed(2)}";
  }
}
