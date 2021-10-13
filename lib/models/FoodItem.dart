abstract class FoodItem {
  String name;
  double quantity;
  // String category;
  // DateTime _expiryDate;
  FoodItem(this.name, this.quantity);

  DateTime get expiration;
}