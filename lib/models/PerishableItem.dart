import 'package:whats_for_dinner/models/FoodItem.dart';

class PerishableItem extends FoodItem {
  DateTime expiryDate;
  PerishableItem(String name, double quantity, [this.expiryDate])
      : super(name, quantity);

  DateTime get expiration => expiryDate;
}