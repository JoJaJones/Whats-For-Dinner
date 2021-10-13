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
    var expiry = DateTime.now().add(const Duration(days: 365));
    expect(p.ingredientString, equals("${TOMATO},${CORN}")); // might need to be updated if sorting method (no sort) changes
    expect(p.ingredientCounts[CORN], moreOrLessEquals(5));
    expect(isClose(p.pantryItems[CORN].items[0].expiration, expiry), equals(true));
  });

  test("Add new perishable item", () {
    var now = DateTime.now();
    p.addIngredient(BEANS, 2, now);
    expect(p.ingredientString, equals("${TOMATO},${CORN},${BEANS}")); // might need to be updated if sorting method (no sort) changes
    expect(p.ingredientCounts[BEANS], moreOrLessEquals(2));
    expect(isClose(p.pantryItems[BEANS].items[0].expiration, now), equals(true));
  });

  test("Remove an item in increments", (){
    p.removeIngredients(TOMATO, 3);
    expect(p.ingredientCounts[TOMATO], moreOrLessEquals(4));
    p.removeIngredients(TOMATO, 2);
    expect(p.ingredientCounts[TOMATO], moreOrLessEquals(2));
    p.removeIngredients(TOMATO, 3);
    expect(p.ingredientCounts.containsKey(TOMATO), equals(false));
  });
}

bool isClose(DateTime time1, DateTime time2, [int dMilliSeconds = 1000]){
  Duration difference = Duration(milliseconds: dMilliSeconds);
  return time1.isBefore(time2.add(difference))
      && time1.isAfter(time2.subtract(difference));
}