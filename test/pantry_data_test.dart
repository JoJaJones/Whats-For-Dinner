import 'package:flutter_test/flutter_test.dart';
import 'package:whats_for_dinner/models/Pantry.dart';

const TOMATO = 'tomato';
const CORN = 'corn';
const BEANS = 'beans';

void main(){

  Pantry p = Pantry();
  test("Add 1 item to pantry", (){
    p.addIngredient(TOMATO, 3);
    expect(p.ingredientString, equals(TOMATO));
    expect(p.ingredientCounts[TOMATO], moreOrLessEquals(3));
  });

  test("Add more of existing item to pantry", (){
    p.addIngredient(TOMATO, 4);
    expect(p.ingredientString, equals(TOMATO));
    expect(p.ingredientCounts[TOMATO], moreOrLessEquals(7));
  });

  test("Add new item to pantry", (){
    p.addIngredient(CORN, 5);
    expect(p.ingredientString, equals("${TOMATO},${CORN}"));
    expect(p.ingredientCounts[CORN], moreOrLessEquals(5));
  });
}