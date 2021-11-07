/// *******************************************************************
/// Spoonacular api interactions to get recipe information (currently just
///  getting information by recipe ID)
///
/// This will likely just be one major api dart file, for now just
/// making it dedicated to recipes.
///*******************************************************************/
import 'dart:convert';
import 'package:whats_for_dinner/models/Recipe.dart';
import 'package:http/http.dart' as http;
import '../models/Recipe.dart';
import '../utils/api_key.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class RecipesApi {
  /// *******************************************************************
  /// Calls the findByIngredients Spoonacular endpoint, using a list of
  /// ingredient names, and then returns a list of recipe IDs that use
  /// those ingredients
  ///*******************************************************************/
  static Future<List> fetchRecipeIds(url, ingredients, {number = 1}) async {
    url = url + '&ingredients=';
    for (var item in ingredients) {
      if (item == ingredients[0]) {
        url = url + item;
      } else {
        url = url + ',+' + item;
      }
    }
    url = url + '&number=' + number.toString();
    var rawResponse = await http.get(Uri.parse(url));
    if (rawResponse.statusCode == 200) {
      final List decodedRecipeIDs = json.decode(rawResponse.body);
      return decodedRecipeIDs;
    } else
      throw Exception('Failed to get recipe IDs using ingredients');
  }

  /// *******************************************************************
  /// Calls the informationBulk Spoonacular endpoint, using a list of
  /// recipe IDs, and then returns a list of raw JSON for each of the recipes
  /// associated with those IDs
  ///*******************************************************************/
  static Future<List> fetchRecipeInfo(url, recipeIDs) async {
    url = url + '&ids=';
    for (var item in recipeIDs) {
      if (item == recipeIDs[0] || item == recipeIDs[recipeIDs.length - 1]) {
        url = url + item;
      } else {
        url = url + item + ',';
      }
    }
    var rawResponse = await http.get(Uri.parse(url));
    if (rawResponse.statusCode == 200) {
      final List decodedRecipeInfo = json.decode(rawResponse.body);
      return decodedRecipeInfo;
    } else
      throw Exception('Failed to get recipe information using Recipe IDs');
  }

  static Future<bool> doesDocExist (docID) async {
    return FirebaseFirestore.instance.collection("recipes").doc(docID).get().then((doc) => {
         return doc.exists
    });
    /*
      var itemFound = FirebaseFirestore
                      .instance
                      .collection('doc_folder')
                      .where("id", isEqualTo: 
                      item.id.toString())
                      .get();
      if(itemFound.exist){

      }
    */
}

  /// *******************************************************************
  /// Generates a list of Recipe objects based on objects in the pantry
  ///*******************************************************************/
  static Future<List<Recipe>> getRecipes() async {
    final String getRecipeIDsUrl =
        "https://api.spoonacular.com/recipes/findByIngredients?apiKey=" +
            API_KEY;

    final String getRecipeInfoURL =
        "https://api.spoonacular.com/recipes/informationBulk?apiKey=" + API_KEY;

    // needs to be replaced with the ingredients in our pantry
    List ingredients = ["eggs", "milk"];

    // get relevant recipes for current ingredients
    final List decodedRecipeIDsJSON =
        await fetchRecipeIds(getRecipeIDsUrl, ingredients);

    // fill a List with the IDs that were grabbed by our ingredients
    // this should be replaced/expanded to only keep recipe IDs that we don't
    // have information stored in firebase for (maybe on a 1 week duration)
    List recipeIDs = [];
    for (var entry in decodedRecipeIDsJSON) {
      recipeIDs.add(entry["id"].toString());
    }

    // get recipe information JSON
    final List recipesJSON = await fetchRecipeInfo(getRecipeInfoURL, recipeIDs);

    // generate recipe objects based on recipe information response
    // this needs to be changed to come from recipe information stored
    // in firebase
    List<Recipe> recipeList =
        recipesJSON.map((json) => Recipe.fromJson(json)).toList();

    for (Recipe item in recipeList) {
      //final snapShot = await FirebaseFirestore.instance.collection('recipes').doc((item.id.toString())).get();

      FirebaseFirestore.instance.collection('recipes').add({'id': item.id});
    }
    return recipeList;
  }

  /// *******************************************************************
  /// Searches the current set of Recipe objects for those that match a
  /// given search query
  ///*******************************************************************/
  static Future<List<Recipe>> searchRecipes(String query) async {
    List<Recipe> recipeList = await getRecipes();
    return recipeList.where((recipe) {
      final titleLower = recipe.title.toLowerCase();
      final summaryLower = recipe.summary.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          summaryLower.contains(searchLower);
    }).toList();
  }
}
