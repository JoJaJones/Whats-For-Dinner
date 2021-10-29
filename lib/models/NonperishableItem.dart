import 'package:whats_for_dinner/models/FoodItem.dart';

/// *******************************************************************
/// Class to represent an ingredient that does not have a limited
/// shelf life
/// *******************************************************************
class NonperishableItem extends FoodItem {
  NonperishableItem(String name, double quantity)
      : super(name, quantity);

  DateTime get expiration {
    var now = DateTime.now();
    return now.add(const Duration(days: 365));
  }
}