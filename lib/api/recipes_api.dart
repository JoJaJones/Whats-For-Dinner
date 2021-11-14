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
import '../controllers/FirestoreController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_for_dinner/models/Pantry.dart';

class RecipesApi {
  //final firestore = new FirestoreController();

  // resulting json map keys
  static CollectionReference recipesDB =
      FirebaseFirestore.instance.collection('recipes');
  static const String QUERY = 'query';
  static const String STATUS = 'status';
  static const String RESULTS = 'results';
  static const String NAME = 'name';
  static const NUM_RECIPES = "1";

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
  static List ingredients = ["milk"];

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
    int lastIndex = listItems.length - 1;
    if (listItems.length == 1) {
      firstQueryEnd = "";
    }
    for (var item in listItems) {
      if (item == listItems[0]) {
        query += item + firstQueryEnd;
      } else if (item == listItems[lastIndex]) {
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
    print("its already in there returning false");
    return false;
  }


  /// **************************************************************************
  /// Function to add new recipe information to the recipes collection in
  /// firebase
  /// **************************************************************************
  static void addRecipes(recipeIDs) async {
    // fetch info for recipe ids not in firebase
    var infoRes = await _fetchJSON(
        buildReqURL(RECIPE_INFO, {"ids": buildReqQuery(',', recipeIDs)}));
    final List recipesJSON = await json.decode(infoRes.body);

    // generate recipe objects based on recipe information response
    // this needs to be changed to come from recipe information stored
    // in firebase
    List<Recipe> recipeList =
        recipesJSON.map((json) => Recipe.fromJson(json)).toList();

    for (Recipe item in recipeList) {
      recipesDB.add(item.toJson());
    }
  }

  /// **************************************************************************
  /// Function to get all recipes from firebase that match the provided set of
  /// of recipe IDs
  /// **************************************************************************
  static Future<List<Recipe>> getRecipesFromFirebase(recipeIDs) async {
    print("starting getrecipes from firebase");
    List<Recipe> result = [];
    var stuff = await FirebaseFirestore.instance
        .collection('recipes')
        .where('id', whereIn: recipeIDs)
        .get();
    stuff.docs.forEach((doc) {
      print((doc.data())["image"]);
      result.add(Recipe.fromJson(doc.data()));
    });
    List<Recipe> myresult = [];
    return result;
  }

  /// *******************************************************************
  /// Generates a list of Recipe objects based on objects in the pantry and
  /// adds to firebase as needed
  ///*******************************************************************/
  static Future<List<Recipe>> getRecipes() async {
    List<Recipe> recipeList = [];
    List recipeIDs = [];
    List newRecipeIDs = [];
    //List tempRecipes = [639637, 664327];

    // get relevant recipes for current ingredients
    Map<String, String> getIdQuery = {
      "number": NUM_RECIPES,
      "ingredients": buildReqQuery(',+', ingredients)
    };
    var idRes = await _fetchJSON(buildReqURL(RECIPE_IDS, getIdQuery));
    print(json.decode(idRes.body));
    final List recipeIDsResponse = await json.decode(idRes.body);

    // remove IDs for recipes that are already in firebase from our recipeIDlist

    for (var entry in recipeIDsResponse) {
      recipeIDs.add(entry["id"]);
      if (await checkIfRecipeInfoNeeded(entry["id"])) {
        newRecipeIDs.add(entry["id"].toString());
      }
    }
    if (newRecipeIDs.length != 0) {
      addRecipes(newRecipeIDs);
      
      var infoRes = await _fetchJSON(
          buildReqURL(RECIPE_INFO, {"ids": buildReqQuery(',', recipeIDs)}));
      final List recipesJSON = await json.decode(infoRes.body);

      // generate recipe objects based on recipe information response
      // this needs to be changed to come from recipe information stored
      // in firebase
      recipeList = recipesJSON.map((json) => Recipe.fromJson(json)).toList()

    }
    return await getRecipesFromFirebase(recipeIDs);
    //return await getRecipesFromFirebase(recipeIDs);
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
