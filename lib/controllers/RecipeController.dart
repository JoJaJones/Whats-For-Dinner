import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_for_dinner/api/recipes_api.dart';
import 'package:whats_for_dinner/controllers/FirestoreController.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/models/Recipe.dart';

import '../models/Recipe.dart';

class RecipeController {
  Map filters = {
    "Chinese": false,
    "Italian": false,
    "Mexican": false,
    "Vegetarian": false,
    "Vegan": false,
    "PantryOnly": false,
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
  /// Function to load recipes from a given user's collection
  /// **************************************************************************
  static Future<List<Recipe>> loadRecipesFromUserCollection(
      String collection) async {
    List<Recipe> firestoreRecipes = [];
    var recipes = firestore.readUserDatabaseEntryList(collection);
    recipes.listen((snapshot) {
      List<DocumentSnapshot> recipeData = snapshot.docs;
      recipeData.forEach((doc) {
        Recipe curRecipe = Recipe.fromJson(doc.data() as Map<String, dynamic>);
        firestoreRecipes.add(curRecipe);
      });
    });
    return firestoreRecipes;
  }

  /// **************************************************************************
  /// Function to add new recipe information for a user to the passed-in
  /// collection based on the passed list of recipe IDs
  /// **************************************************************************
  static Future<void> addRecipesToUserCollection(
      String newRecipeID, String collection) async {
    print("fetching recipe info for ${newRecipeID}");
    List<Recipe> newRecipes = await RecipesApi.getRecipeInfo([newRecipeID]);
    for (Recipe item in newRecipes) {
      await firestore.addEntryToUserDoc(
          collection, item.id.toString(), item.toJson());
    }
  }

  /// **************************************************************************
  /// Function to add new recipe information for a user to the passed-in
  /// collection based on the passed list of recipe IDs
  /// **************************************************************************
  static Future<void> deleteRecipeFromUserCollection(
      String recipeID, String collection) async {
    firestore.deleteUserDoc(collection, recipeID);
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
