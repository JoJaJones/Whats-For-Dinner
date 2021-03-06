// import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whats_for_dinner/models/NonperishableItem.dart';
import 'package:whats_for_dinner/models/Pantry.dart';
import 'package:whats_for_dinner/models/PerishableItem.dart';

import 'FoodItem.dart';

/// *******************************************************************
/// Class to hold a collection of ingredients of the same type and
/// allow manipulations of the ingredients it represents. (This class
/// is meant to correctly handle perishable items since items purchased
/// at different times may expire at different times either multiple
/// copies of specific ingredients of the same type would need to be
/// in the pantry or an organizing object is needed)
/// *******************************************************************
class IngredientType {
  static const String NAME = 'name';
  static const String PERISHABLE = 'perishable';
  static const String ITEMS = 'items';

  String name;
  bool  isPerishable;
  List<FoodItem> items;

  IngredientType(this.name, this.isPerishable)
      : items = new List<FoodItem>.empty(growable: true);

  IngredientType.fromMap(Map<String, dynamic> data)
      : name = data[ITEMS][0][NAME],
        isPerishable = data[PERISHABLE],
        items = new List<FoodItem>.empty(growable: true) {
    data[ITEMS].forEach((element) {
      addIngredientFromMap(element);
    });
  }

  double get quantity {
    double sum = 0;
    items.forEach((element) {
      sum += element.quantity;
    });

    return sum;
  }

  void addIngredientFromMap(Map<String, dynamic> data) {
    double quantity = data[FoodItem.QUANTITY];
    DateTime? expiration;
    if(isPerishable) {
      expiration = data[FoodItem.EXPIRY].toDate();
    }

    addIngredient(quantity, expiration);
  }

  void addIngredient(double quantity, [DateTime? expiration]){
    var newItem;
    if (isPerishable){
      newItem = PerishableItem(name, quantity, expiration);
    } else {
      newItem = NonperishableItem(name, quantity);
    }
    items.add(newItem);
    sortByDate();
  }

  void removeIngredient(double quantity){
    sortByDate();
    while (quantity > 0 && items.length > 0){
      items[0].quantity -= quantity;

      // if quantity to be removed is greater than the amount available correct
      // quantity and remove first item
      if(items[0].quantity <= 0){
        quantity = -items[0].quantity;
        items.removeAt(0);
      } else {
        quantity = 0;
      }
    }
  }

  bool get isOutOfStock => quantity <= 0;

  DateTime get earliestExpiration {
    sortByDate();
    return items[0].expiration;
  }

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data[PERISHABLE] = isPerishable;
    data[ITEMS] = List<Map<String, dynamic>>.empty(growable: true);

    items.forEach((element) {
      data[ITEMS].add(element.toMap());
    });

    return data;
  }

  double get numExpired {
    if(!isPerishable) {
      return 0;
    }
    double count = 0;
    int idx = 0;
    while( idx < items.length && items[idx].expiration.compareTo(DateTime.now()) < 0){
      count += items[idx].quantity;
      idx += 1;
    }

    return count;
  }

  void sortByDate(){
    if(isPerishable) {
      items.sort((a, b) => a.expiration.compareTo(b.expiration));
    }
  }
}