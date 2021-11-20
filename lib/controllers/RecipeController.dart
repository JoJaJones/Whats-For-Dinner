import 'package:whats_for_dinner/api/recipes_api.dart';
import 'package:whats_for_dinner/models/Recipe.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/controllers/FirestoreController.dart';
import '../models/Recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeController {
  Map filters = {
    "Chinese": false,
    "Italian": false,
    "Mexican": false,
    "Vegetarian": false,
    "Vegan": false,
    "IgnorePantry": false,
  };
  static var pantry = PantryManager();
  static var firestore = FirestoreController();
  static List<Recipe> allRecipes = [];

  /// **************************************************************************
  /// Function to load all recipes currently in firebase
  /// **************************************************************************
  static void loadRecipes() {
    List<Recipe> firestoreRecipes = [];
    var recipes = firestore.readDatabaseEntryList('recipes');
    recipes.listen((snapshot) {
      List<DocumentSnapshot> recipeData = snapshot.docs;
      recipeData.forEach((doc) {
        Recipe curRecipe = Recipe.fromJson(doc.data() as Map<String, dynamic>);
        firestoreRecipes.add(curRecipe);
      });
    });
    allRecipes = firestoreRecipes;
  }

  /// **************************************************************************
  /// Function to add new recipe information to the recipes collection in
  /// firebase
  /// **************************************************************************
  static void updateFirestore() async {
    List newRecipeIDs = [];
    print(
        "there are ${pantry.ingredientCounts} ingredients: ${pantry.ingredientString}");
    if (pantry.ingredientString.length != 0) {
      print("Loading ingredients");
      List ingredientList = pantry.ingredientString.split(',');
      // grab recipe IDs for recipes retrieved from spoonacular that aren't
      // already stored in our database
      newRecipeIDs = await RecipesApi.getRecipeIDs((ingredientList));
      // if new recipe IDs were found, fetch their info, and add to firebase
      if (newRecipeIDs.length != 0) {
        print("fetching recipe info for ${newRecipeIDs}");
        List<Recipe> newRecipes = await RecipesApi.getRecipeInfo(newRecipeIDs);
        for (Recipe item in newRecipes) {
          firestore.addEntryToCollection('recipes', item.toJson());
        }
      }
    }
  }

  /// *******************************************************************
  /// Returns all relevant recipes for current pantry
  ///*******************************************************************/
  static Future<List<Recipe>> getAllRecipes() async {
    updateFirestore();
    loadRecipes();
    return allRecipes;
  }

  /// *******************************************************************
  /// Function to ensure that a given recipe meets all filter criteria
  ///*******************************************************************/
  static bool meetsFilterCriteria(Recipe recipe) {
    return true;
  }

  /// *******************************************************************
  /// Searches the current list of Recipe objects for those that match a
  /// given search query
  ///*******************************************************************/
  static Future<List<Recipe>> searchRecipes(String query) async {
    return allRecipes.where((recipe) {
      final titleLower = recipe.title.toLowerCase();
      final summaryLower = recipe.summary.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          summaryLower.contains(searchLower) && meetsFilterCriteria(recipe);
    }).toList();
  }
}
