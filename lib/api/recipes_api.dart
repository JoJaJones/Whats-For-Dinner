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
import 'package:flutter/services.dart' show rootBundle;
import '../models/Recipe.dart';
import '../utils/api_key.dart';

Future<String> readApiKey() async {
  return await rootBundle.loadString('./apikey');
}

Future<String> readRecipesJson() async {
  return await rootBundle.loadString('recipeInformation.json');
}

class RecipesApi {
  static const String QUERY = 'query';
  static const String STATUS = 'status';
  static const String RESULTS = 'results';
  static const String NAME = 'name';

  static const String INGREDIENT = "ingredient";
  static const apiBaseURL = "https://api.spoonacular.com/";
  static const apiArgStr = "apiKey";
  static var endPointMap = {
    INGREDIENT: "food/ingredients/search",
  };

  /// **************************************************************************
  /// This function will build the endpoint URL from a string value that
  /// represents the type of search wanted. You must also include a Map with at
  /// least the key value pair for the key 'query'
  /// *************************************************************************/
  static String buildReqURL(String endpoint_key, Map<String, String> argPairs){
    String url = apiBaseURL;

    if(endPointMap.containsKey(endpoint_key)){
      url += "${endPointMap[endpoint_key]}?${apiArgStr}=${API_KEY}";
    }

    if(argPairs != null){
      argPairs.forEach((key, value) {
        url += "&$key=$value";
      });
    }

    return url;
  }

  static Future<http.Response> _fetchJSON(String target) {
    // todo: error handling for no internet.
    return http.get(Uri.parse(target));
  }

  /// **************************************************************************
  /// Function to interpolate the destination, main search query and additional
  /// parameters into a set of data ready for http request.
  /// **************************************************************************
  static Future<http.Response> _makeQuery(String target, String query, [Map<String, String>? params]){
    if (params == null){
      params = Map<String, String>();
    }
    params[QUERY] = query;

    return _fetchJSON(buildReqURL(INGREDIENT, params));
  }

  /// **************************************************************************
  /// Function to convert the http.Response object to a map
  /// **************************************************************************
  static Map<String, dynamic> _processResponse(http.Response res){
    if (res.statusCode == 200){
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
  static Future<Map<String, dynamic>> getIngredients(String query, [Map<String, String>? params]) async {
    var res = await _makeQuery(INGREDIENT, query, params);

    return _processResponse(res);
  }

  /// **************************************************************************
  /// Function to check if the map representing a specific ingredient exists in
  /// a list of maps
  /// **************************************************************************
  static bool ingredientMapExists(String query, List<dynamic> ingredients){
    bool foundIngredient = false;
    ingredients.forEach((value) {
      if(value[NAME] == query){
        foundIngredient = true;
      }
    });

    return foundIngredient;
  }

  /// **************************************************************************
  /// Function to verify an ingredient exists in a spoonacular response map
  /// **************************************************************************
  static bool validateIngredientRes(String query, Map<String, dynamic> ingredients){
    return ingredientMapExists(query, ingredients[RESULTS]);
  }

  /// **************************************************************************
  /// Function to validate an ingredient via a spoonacular request
  /// **************************************************************************
  static Future<bool> validateIngredient(String query) async{
    var ingredients = await getIngredients(query);
    if(ingredients[STATUS] == 200) {
      return validateIngredientRes(query, ingredients);
    } else {
      return false;
    }
  }


  /* TODO: Petyon, see the getIngredients function and buildReqURL functions for
           reference on how to handle this. You'll need to add your endpoints to
           the endpointMap for those functions to work for you.
  */
  static Future<List<Recipe>> getRecipes(String query) async {
    //final apiKey = await readApiKey();

    // placeholder before api integration is actually implemented
    // we will first need to search by ingredients, and then take the resulting
    // recipe ids and search on those for their associated information
    // 'recipesByIdResponse' is a file with the raw response data from a call
    // to that api route
    var recipesByIDResponse = await readRecipesJson();
    final List recipes = json.decode(recipesByIDResponse);
    return recipes.map((json) => Recipe.fromJson(json)).where((recipe) {
      final titleLower = recipe.title.toLowerCase();
      final summaryLower = recipe.summary.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          summaryLower.contains(searchLower);
    }).toList();
  }
}
