import 'package:whats_for_dinner/models/FoodItem.dart';

class NonperishableItem extends FoodItem {
  NonperishableItem(String name, double quantity)
      : super(name, quantity);

  DateTime get expiration {
    var now = DateTime.now();
    return now.add(const Duration(days: 365));
  }
}