import 'package:whats_for_dinner/api/recipes_api.dart';
import 'package:whats_for_dinner/models/Recipe.dart';
import 'package:whats_for_dinner/controllers/PantryManager.dart';
import 'package:whats_for_dinner/controllers/FirestoreController.dart';
import '../models/Recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

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
  static List<Recipe> pantryRecipes = [];

  /// **************************************************************************
  /// Function to load all recipes currently in firebase
  /// **************************************************************************
  static void loadRecipes() {
    print("loading recipes");
    List<Recipe> firestoreRecipes = [];
    var recipes = firestore.readDatabaseEntryList('recipes');
    recipes.listen((snapshot) {
      List<DocumentSnapshot> recipeData = snapshot.docs;
      recipeData.forEach((doc) {
        Recipe curRecipe = Recipe.fromJson(doc.data() as Map<String, dynamic>);
        firestoreRecipes.add(curRecipe);
      });
      pantryRecipes = determinePantryRecipes(firestoreRecipes);
    });
    allRecipes = firestoreRecipes;
  }

  static List<Recipe> determinePantryRecipes(recipeList) {
    List<Recipe> pantryList = [];
    List pantryIngredients = pantry.ingredientString.split(',');
    for (Recipe recipe in recipeList) {
      bool notFound = true;
      for (var recipeIngredient in recipe.extendedIngredients) {
        String curRecipeIngredient =
            (recipeIngredient["name"]?.toLowerCase() ?? "").toLowerCase();
        if (notFound) {
          for (String pantryIngredient in pantryIngredients) {
            String curPantryIngredient = pantryIngredient.toLowerCase();
            if (ratio(curRecipeIngredient, curPantryIngredient) >= 75) {
              pantryList.add(recipe);
              notFound = false;
            }
          }
        } else {
          break;
        }
      }
    }
    return pantryList;
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
      print(pantry.ingredientString);
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
  /// Returns all recipes from database
  ///*******************************************************************/
  static Future<List<Recipe>> getAllRecipes() async {
    updateFirestore();
    loadRecipes();
    return allRecipes;
  }

  /// *******************************************************************
  /// Returns all relevant recipes for current pantry
  ///*******************************************************************/
  static Future<List<Recipe>> getAllPantryRecipes() async {
    updateFirestore();
    loadRecipes();
    return pantryRecipes;
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
  static Future<List<Recipe>> searchRecipes(String query,
      {pantry = false}) async {
    if (pantry) {
      return pantryRecipes.where((recipe) {
        final titleLower = recipe.title.toLowerCase();
        final summaryLower = recipe.summary.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower) ||
            summaryLower.contains(searchLower) && meetsFilterCriteria(recipe);
      }).toList();
    }
    return allRecipes.where((recipe) {
      final titleLower = recipe.title.toLowerCase();
      final summaryLower = recipe.summary.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          summaryLower.contains(searchLower) && meetsFilterCriteria(recipe);
    }).toList();
  }
}
