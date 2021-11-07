import 'package:flutter_test/flutter_test.dart';
import 'package:whats_for_dinner/api/recipes_api.dart';
import 'package:whats_for_dinner/utils/api_key.dart';

void main() async{
  test("Test URL generation", (){
    var URL = RecipesApi.buildReqURL(RecipesApi.INGREDIENT, {"query":""});
    expect(URL, equals("https://api.spoonacular.com/food/ingredients/search?apiKey=$API_KEY&query="));
  });

  print(RecipesApi.validateIngredient("appe"));
}