import 'IngredientType.dart';

/// *******************************************************************
/// Data class for tracking all of the ingredients the user has added
/// to their pantry
/// *******************************************************************
class Pantry {
  Map<String, IngredientType> pantryItems;

  Pantry(){
    pantryItems = new Map<String, IngredientType>();
  }

  bool addIngredient(String name, double quantity, [DateTime expiration = null]){
    if(pantryItems.containsKey(name)){
      pantryItems[name].addIngredient(quantity, expiration);
    } else {
      _addNewIngredient(name, quantity, expiration != null, expiration);
    }

    return true;
  }
  
  void _addNewIngredient(
      String name, 
      double quantity, 
      bool isPerishable, 
      DateTime expiration) {
    // validate the ingredient using spoonacular API
    pantryItems[name] = IngredientType(name, isPerishable);
    pantryItems[name].addIngredient(quantity, expiration);
  }

  bool removeIngredients(String name, double quantity){
    if(pantryItems.containsKey(name)){
      pantryItems[name].removeIngredient(quantity);
      if(pantryItems[name].isOutOfStock){
        pantryItems.remove(name);
      }
      return true;
    }

    return false;
  }

  List<IngredientType> get ingredientsData => pantryItems.values.toList();

  List<String> get ingredientList => pantryItems.keys.toList();

  String get ingredientString => ingredientList.join(",");

  Map<String, double> get ingredientCounts {
    return pantryItems.map((key, value) => MapEntry(key, value.quantity));
  }
}