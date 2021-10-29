/// *******************************************************************
/// This is an abstract class to represent an ingredient
///
/// It is specialized into perishable and non-perishable derived
/// classes
/// *******************************************************************
abstract class FoodItem {
  String name;
  double quantity;
  // String category;
  FoodItem(this.name, this.quantity);

  DateTime get expiration;
}