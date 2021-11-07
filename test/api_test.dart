import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:whats_for_dinner/api/recipes_api.dart';
import 'package:whats_for_dinner/utils/api_key.dart';

void main() async{
  test("Test URL generation", (){
    var URL = RecipesApi.buildReqURL(RecipesApi.INGREDIENT, {"query":""});
    expect(URL, equals("https://api.spoonacular.com/food/ingredients/search?apiKey=$API_KEY&query="));
  });

  /*
  test("Test getIngredients functionality", () async {
    var testIngredient = "apple";
    var res = await RecipesApi.getIngredients(testIngredient);
    bool found = false;
    int status;

    status = res[RecipesApi.STATUS];
    if(status == 200) {
      found = RecipesApi.validateIngredientRes(testIngredient, res);
    }

    if(status == 200) {
      expect(found, equals(true));
    } else {
      print(status);
    }

    testIngredient = "zzzzzzz";
    res = await RecipesApi.getIngredients(testIngredient);
    found = false;

    status = res[RecipesApi.STATUS];
    if(status == 200) {
      found = RecipesApi.validateIngredientRes(testIngredient, res);
    }

    if(status == 200) {
      expect(found, equals(false));
    } else {
      print(status);
    }
  });
  // */ // the // comment allows the previous multi line comment to be turned on/off solely by commenting out the initiator
}