import 'package:whats_for_dinner/models/FoodItem.dart';

/// *******************************************************************
/// Class to represent an ingredient that has a limited shelf life
/// *******************************************************************
class PerishableItem extends FoodItem {
  DateTime expiryDate;
  PerishableItem(String name, double quantity, [DateTime? expiry])
      : expiryDate = expiry ?? DateTime.utc(1900), super(name, quantity);

  DateTime get expiration => expiryDate;

  Map<String, dynamic> toMap() {
    var itemMap = Map<String, dynamic>();

    super.toMap().forEach((key, value) {
      itemMap[key] = value;
    });

    itemMap[FoodItem.EXPIRY] = expiryDate;

    return itemMap;
  }
}