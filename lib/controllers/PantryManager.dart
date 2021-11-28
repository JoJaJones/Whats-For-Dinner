import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_for_dinner/controllers/FirestoreController.dart';
import 'package:whats_for_dinner/models/IngredientType.dart';
import 'package:whats_for_dinner/models/Pantry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_for_dinner/controllers/RecipeController.dart';

/// *******************************************************************
/// Singleton to manage Pantry and allow access from any screen of
/// the app. Will also load the pantry from firebase when the app is
/// booted (if user is logged in) or upon user log in
///*******************************************************************/
class PantryManager {
  static final PantryManager _manager = PantryManager._internal();
  static const PANTRY_COLLECTION = "PantryItems";
  static const NAME_KEY = "name";
  static const QUANTITY_KEY = "quantity";
  static const EXPIRATION_KEY = "expiration";
  bool isLoaded;

  static String? userId;

  Pantry pantry;

  factory PantryManager() {
    return _manager;
  }

  void clear() {
    pantry = Pantry();
    isLoaded = false;
  }

  PantryManager._internal() : pantry = Pantry(), isLoaded = false {
    print("Pantry Manager internal");
    // read from firebase DB and load pantry with contained data
    if (size == 0) {
      loadPantry();
    }
  }

  Future<bool> loadPantry() async {
    if(size == 0) {
      var data =
      FirestoreController().readUserDatabaseEntryList(PANTRY_COLLECTION);
      await pantry.loadFromMap(data);
      return true;
    } else {
      return true;
    }
  }

  bool addItem(String name, double quantity, [DateTime? expiry]) {
    if(size == 0){
      loadPantry();
    }

    bool isValid = true;
    // check with API for validity

    // add item to pantry
    pantry.addIngredient(name, quantity, expiry);
    // add item to firebase db

    FirestoreController().addEntryToUserDoc(
        PANTRY_COLLECTION, name, pantry.pantryItems[name]!.toMap());

    // add recipes for these ingredients to firestore
    RecipeController.updateFirestore();
    return isValid;
  }

  bool removeItem(String name, double quantity) {
    bool isValid = false;
    // check api for validity
    if (pantry.removeIngredients(name, quantity)) {
      var fc = FirestoreController();

      if (pantry.pantryItems.containsKey(name)) {
        fc.addEntryToUserDoc(
            PANTRY_COLLECTION, name, pantry.pantryItems[name]!.toMap());
      } else {
        fc.deleteUserDoc(PANTRY_COLLECTION, name);
      }
    }

    return isValid;
  }

  List<IngredientType> get ingredients => pantry.ingredientsData;

  String get ingredientString => pantry.ingredientString;

  Map<String, double> get ingredientCounts => pantry.ingredientCounts;

  int get size => ingredients.length;
}
