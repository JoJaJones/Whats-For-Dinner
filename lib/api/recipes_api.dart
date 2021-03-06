/// *******************************************************************
/// Spoonacular api interactions to get recipe information (currently just
///  getting information by recipe ID)
///
/// This will likely just be one major api dart file, for now just
/// making it dedicated to recipes.
///*******************************************************************/
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:whats_for_dinner/models/Recipe.dart';

import '../models/Recipe.dart';
import '../utils/api_key.dart';

class RecipesApi {
  // resulting json map keys
  static CollectionReference recipesDB =
      FirebaseFirestore.instance.collection('recipes');
  static const String QUERY = 'query';
  static const String STATUS = 'status';
  static const String RESULTS = 'results';
  static const String NAME = 'name';
  static const NUM_RECIPES = "5";

  // endpoint keys and map
  static const String INGREDIENT = "ingredient";
  static const String RECIPE_IDS = "recipe_ids";
  static const String RECIPE_INFO = "recipe_info";
  static var endPointMap = {
    INGREDIENT: "food/ingredients/search",
    RECIPE_IDS: "recipes/findByIngredients",
    RECIPE_INFO: "recipes/informationBulk",
  };

  // URL components common to all requests
  static const API_BASE_URL = "https://api.spoonacular.com/";
  static const API_ARG_STR = "apiKey";

  // PLACEHOLDER - needs to be replaced with the ingredients in our pantry
  //static List ingredients = ["sugar", "flour"];

  //static Future<List<Recipe>> recipeList = getRecipes();

  /// **************************************************************************
  /// This function will build the endpoint URL from a string value that
  /// represents the type of search wanted. You must also include a Map with at
  /// least the key value pair for the key 'query'
  /// *************************************************************************/
  static String buildReqURL(String endpointKey, Map<String, String> argPairs) {
    String url = API_BASE_URL;

    if (endPointMap.containsKey(endpointKey)) {
      url += "${endPointMap[endpointKey]}?$API_ARG_STR=$API_KEY";
    }

    if (argPairs != null) {
      argPairs.forEach((key, value) {
        url += "&$key=$value";
      });
    }

    return url;
  }

  static Future<http.Response> _fetchJSON(String target) {
    // todo: error handling for no internet since Uri.parse requires internet connection.
    return http.get(Uri.parse(target));
  }

  /// **************************************************************************
  /// Function to interpolate the destination, main search query and additional
  /// parameters into a set of data ready for http request.
  /// **************************************************************************
  static Future<http.Response> _makeQuery(String target, String query,
      [Map<String, String>? params]) {
    if (params == null) {
      params = Map<String, String>();
    }
    params[QUERY] = query;

    return _fetchJSON(buildReqURL(INGREDIENT, params));
  }

  /// **************************************************************************
  /// Function to convert the http.Response object to a map
  /// **************************************************************************
  static Map<String, dynamic> _processResponse(http.Response res) {
    if (res.statusCode == 200) {
      var ingredientJSON = jsonDecode(res.body);
      ingredientJSON[STATUS] = 200;
      return ingredientJSON;
    } else {
      return {STATUS: res.statusCode};
    }
  }

  /// **************************************************************************
  /// Function to get a map of the results of the ingredient search. Will at the
  /// minimum contain a key value pair representing the http response code for
  /// the request
  /// **************************************************************************
  static Future<Map<String, dynamic>> getIngredients(String query,
      [Map<String, String>? params]) async {
    var res = await _makeQuery(INGREDIENT, query, params);

    return _processResponse(res);
  }

  /// **************************************************************************
  /// Function to check if the map representing a specific ingredient exists in
  /// a list of maps
  /// **************************************************************************
  static bool ingredientMapExists(String query, List<dynamic> ingredients) {
    bool foundIngredient = false;
    ingredients.forEach((value) {
      if (value[NAME] == query) {
        foundIngredient = true;
      }
    });

    return foundIngredient;
  }

  /// **************************************************************************
  /// Function to verify an ingredient exists in a spoonacular response map
  /// **************************************************************************
  static bool validateIngredientRes(
      String query, Map<String, dynamic> ingredients) {
    return ingredientMapExists(query, ingredients[RESULTS]);
  }

  /// **************************************************************************
  /// Function to validate an ingredient via a spoonacular request
  /// **************************************************************************
  static Future<bool> validateIngredient(String query) async {
    var ingredients = await getIngredients(query);
    if (ingredients[STATUS] == 200) {
      return validateIngredientRes(query, ingredients);
    } else {
      return false;
    }
  }

  /// **************************************************************************
  /// Function to build the param value for a list of items based on a provided
  /// separator for those items
  /// **************************************************************************
  static String buildReqQuery(separator, listItems) {
    String query = "";
    String firstQueryEnd = separator;
    print("hello");
    print(listItems);
    int lastIndex = listItems.length - 1;
    if (listItems.length == 1) {
      firstQueryEnd = "";
    }
    for (var id in listItems) {
      String item = id.toString();
      if (id == listItems[0]) {
        query += item + firstQueryEnd;
      } else if (id == listItems[lastIndex]) {
        query += item;
      } else {
        query += item + separator;
      }
    }
    return query;
  }

  /// **************************************************************************
  /// Function to to check whether a given recipe already exists in firebase
  /// **************************************************************************
  static Future<bool> checkIfRecipeInfoNeeded(id) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();
    if (snapshot.size == 0) return true;
    print("it was found");
    return false;
  }

  /// *******************************************************************
  /// Generates a list of Recipe IDs based on objects in the pantry and
  /// adds to firebase as needed
  ///*******************************************************************/
  static Future<List> getRecipeIDs(ingredientList) async {
    List recipeIDs = [];
    Map<String, String> getIdQuery = {
      "number": NUM_RECIPES,
      "ingredients": buildReqQuery(',+', ingredientList)
    };
    var idRes = await _fetchJSON(buildReqURL(RECIPE_IDS, getIdQuery));
    final List recipeIDsResponse = await json.decode(idRes.body);
    // get array of all recipe ids to get information for, as well as
    // any recipes that need to be fetched from firebase
    for (var entry in recipeIDsResponse) {
      bool needed = await checkIfRecipeInfoNeeded(entry["id"]);
      if (needed) {
        recipeIDs.add(entry["id"]);
        print(entry["id"]);
      }
    }
    return recipeIDs;
  }

  /// *******************************************************************
  /// Generates a list of Recipe objects based on objects in the pantry and
  /// adds to firebase as needed
  ///*******************************************************************/
  static Future<List<Recipe>> getRecipeInfo(recipeIDs) async {
    var infoRes = await _fetchJSON(
        buildReqURL(RECIPE_INFO, {"ids": buildReqQuery(',', recipeIDs)}));
    final List recipesJSON = await json.decode(infoRes.body);
    return recipesJSON.map((json) => Recipe.fromJson(json)).toList();
  }
}
