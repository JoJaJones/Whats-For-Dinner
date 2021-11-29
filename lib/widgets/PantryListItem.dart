import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/models/IngredientType.dart';
import 'package:whats_for_dinner/widgets/EditQuantityDialog.dart';
import 'package:whats_for_dinner/widgets/components/SimpleComponents.dart';

class PantryListItem extends StatelessWidget {
  IngredientType curIngredient;
  int index;
  var refresh;
  static const EXPIRY_ENABLED = true;

  PantryListItem(this.curIngredient, this.index, this.refresh);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: ListTile(
        title: TitleText(curIngredient.name),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: createDetails(),
        ),
        tileColor: Color(CupertinoColors.systemGrey4.value),
        trailing: Column(
          children: [
            GestureDetector(
              child: Icon(
                Icons.add,
                color: Color(Colors.green.value),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    var curIngredient = PantryManager().ingredients[index];
                    return EditQuantityDialog(curIngredient.name, curIngredient.isPerishable, refresh, true);
                  }
                );
              },
            ),
            GestureDetector(
              child: Icon(
                Icons.remove,
                color: Color(Colors.red.value),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    var curIngredient = PantryManager().ingredients[index];
                    return EditQuantityDialog(curIngredient.name, curIngredient.isPerishable, refresh);
                  }
                );
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
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
      Color? color;
      String dateText;
      if(curIngredient.items[0].expiration.compareTo(DateTime.now()) < 0){
        color = Color(Colors.pink.value);
        dateText = "${curIngredient.numExpired} expired: ";
      } else {
        dateText = "use by: ";
      }

      dateText += "${curIngredient.earliestExpiration.month}-"
          "${curIngredient.earliestExpiration.day}-"
          "${curIngredient.earliestExpiration.year}";

      children.add(
        ContentText(dateText, color: color,)
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
