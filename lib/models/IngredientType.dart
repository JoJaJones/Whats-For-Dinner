import 'package:whats_for_dinner/models/NonperishableItem.dart';
import 'package:whats_for_dinner/models/PerishableItem.dart';

import 'FoodItem.dart';

/// *******************************************************************
/// Class to hold a collection of ingredients of the same type and
/// allow manipulations of the ingredients it represents. (This class
/// is meant to correctly handle perishable items since items purchased
/// at different times may expire at different times either multiple
/// copies of specific ingredients of the same type would need to be
/// in the pantry or an organizing object is needed)
/// *******************************************************************
class IngredientType {
  String name;
  bool  isPerishable;
  List<FoodItem> items;

  IngredientType(this.name, this.isPerishable) {
    items = new List<FoodItem>();
  }

  double get quantity {
    double sum = 0;
    items.forEach((element) {
      sum += element.quantity;
    });

    return sum;
  }

  void addIngredient(double quantity, [DateTime expiration]){
    var newItem;
    if (isPerishable){
      newItem = PerishableItem(name, quantity, expiration);
    } else {
      newItem = NonperishableItem(name, quantity);
    }
    items.add(newItem);
  }

  void removeIngredient(double quantity){
    while (quantity > 0 && items.length > 0){
      items[0].quantity -= quantity;

      // if quantity to be removed is greater than the amount available correct
      // quantity and remove first item
      if(items[0].quantity <= 0){
        quantity = -items[0].quantity;
        items.removeAt(0);
      } else {
        quantity = 0;
      }
    }
  }

  bool get isOutOfStock => quantity <= 0;
}