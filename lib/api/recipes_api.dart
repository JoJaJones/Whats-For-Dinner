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
import 'package:whats_for_dinner/utils/api_key.dart';

Future<String> readApiKey() async {
  return await rootBundle.loadString('./apikey');
}

Future<String> readRecipesJson() async {
  return await rootBundle.loadString('recipeInformation.json');
}

class RecipesApi {
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
