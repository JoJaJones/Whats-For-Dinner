abstract class FoodItem {
  String name;
  double quantity;
  // String category;
  FoodItem(this.name, this.quantity);

  DateTime get expiration;
}