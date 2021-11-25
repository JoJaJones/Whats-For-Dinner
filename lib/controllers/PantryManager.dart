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
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static const PANTRY_COLLECTION = "PantryItems";
  static const NAME_KEY = "name";
  static const QUANTITY_KEY = "quantity";
  static const EXPIRATION_KEY = "expiration";

  static String? userId;

  Pantry pantry;

  factory PantryManager() {
    return _manager;
  }

  PantryManager._internal() : pantry = Pantry() {
    // read from firebase DB and load pantry with contained data
    _loadPantry();
  }

  void _loadPantry() {
    userId = auth.currentUser?.uid;
    print(userId);
  }

  bool addItem(String name, double quantity, [DateTime? expiry]) {
    bool isValid = true;
    // check with API for validity

    // add item to pantry
    pantry.addIngredient(name, quantity, expiry);
    // add item to firebase db

    // add recipes for these ingredients to firestore
    RecipeController.updateFirestore();

    return isValid;
  }

  bool removeItem(String name, double quantity) {
    bool isValid = false;
    // check api for validity
    if (pantry.removeIngredients(name, quantity) && isValid) {
      // remove item from pantry

      // update firebase db
    }

    return isValid;
  }

  List<IngredientType> get ingredients => pantry.ingredientsData;

  String get ingredientString => pantry.ingredientString;

  Map<String, double> get ingredientCounts => pantry.ingredientCounts;

  int get size => ingredients.length;
}
