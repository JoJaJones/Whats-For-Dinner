import 'package:whats_for_dinner/api/recipes_api.dart';
import 'package:whats_for_dinner/models/Recipe.dart';

///*******************************************************************/
class RecipeController {
  final recipes = getAllRecipes();

  /// *******************************************************************
  /// Returns all relevant recipes for current pantry
  ///*******************************************************************/
  static Future<List<Recipe>> getAllRecipes() async {
    List<Recipe> list = await RecipesApi.getRecipes();
    return list;
  }

  /// *******************************************************************
  /// Searches the current list of Recipe objects for those that match a
  /// given search query
  ///*******************************************************************/
  static Future<List<Recipe>> searchRecipes(String query) async {
    List<Recipe> recipeList = await RecipesApi.getRecipes();

    return recipeList.where((recipe) {
      final titleLower = recipe.title.toLowerCase();
      final summaryLower = recipe.summary.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          summaryLower.contains(searchLower);
    }).toList();
  }
}
