import 'package:whats_for_dinner/models/IngredientType.dart';
import 'package:whats_for_dinner/models/Pantry.dart';

/// *******************************************************************
/// Singleton to manage Pantry and allow access from any screen of
/// the app. Will also load the pantry from firebase when the app is
/// booted (if user is logged in) or upon user log in
///*******************************************************************/
class PantryManager {
  static final PantryManager _manager = PantryManager._internal();

  static const PANTY_COLLECTION = "PantryItems";
  static const NAME_KEY = "name";
  static const QUANTITY_KEY = "quantity";
  static const EXPIRATION_KEY = "expiration";

  Pantry pantry;

  factory PantryManager(){
    return _manager;
  }

  PantryManager._internal() : pantry = Pantry(){
    // read from firebase DB and load pantry with contained data
  }

  bool addItem(String name, double quantity, [DateTime? expiry]){
    bool isValid = true;
    // check with API for validity

    // add item to pantry

    // add item to firebase db

    return isValid;
  }

  bool removeItem(String name, double quantity) {
    bool isValid = false;
    // check api for validity
    if(pantry.removeIngredients(name, quantity) && isValid) {
      // remove item from pantry

      // update firebase db
    }

    return isValid;
  }

  List<IngredientType> get ingredients => pantry.ingredientsData;

  int get size => ingredients.length;
}