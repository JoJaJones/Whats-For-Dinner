/// *******************************************************************
/// This is an abstract class to represent an ingredient
///
/// It is specialized into perishable and non-perishable derived
/// classes
/// *******************************************************************
abstract class FoodItem {
  static const String NAME = 'name';
  static const String EXPIRY = 'expiry';
  static const String QUANTITY = 'qty';

  String name;
  double quantity;
  // String category;
  FoodItem(this.name, this.quantity);
  FoodItem.fromMap(Map data) : name = data[NAME], quantity = data[QUANTITY];

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data[NAME] = name;
    data[QUANTITY] = quantity;
    return data;
  }

  DateTime get expiration;
}