import 'IngredientType.dart';

class Pantry {
  Map<String, IngredientType> pantryItems;

  Pantry(){
    pantryItems = new Map<String, IngredientType>();
  }

  void addIngredient(String name, double quantity, [DateTime expiration = null]){
    if(pantryItems.containsKey(name)){
      pantryItems[name].addIngredient(quantity, expiration);
    } else {
      _addNewIngredient(name, quantity, expiration != null, expiration);
    }
  }
  
  void _addNewIngredient(
      String name, 
      double quantity, 
      bool isPerishable, 
      DateTime expiration) {
    pantryItems[name] = IngredientType(name, isPerishable);
    pantryItems[name].addIngredient(quantity, expiration);
  }
  
  List<String> get ingredientList => pantryItems.keys.toList();

  String get ingredientString => ingredientList.join(",");

  Map<String, double> get ingredientCounts {
    return pantryItems.map((key, value) => MapEntry(key, value.quantity));
  }
}