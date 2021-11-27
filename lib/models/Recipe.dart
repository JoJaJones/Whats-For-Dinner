/// *******************************************************************
/// Class to represent a recipe
/// *******************************************************************
class Recipe {
  final int id;
  final String title;
  final String summary;
  final int readyInMinutes;
  final String image;
  final int servings;
  final String instructions;
  final List extendedIngredients;
  bool dairyFree;
  bool vegan;
  bool vegetarian;

  final List analyzedInstructions;
  final String sourceName;
  final String sourceUrl;
  //final List allergens ** Missing in response?
  // below is temporary variable, will be replaced with
  // userprofile/firebase integration
  bool favorited;

  Recipe({
    required this.id,
    required this.title,
    required this.summary,
    required this.readyInMinutes,
    required this.image,
    required this.servings,
    required this.favorited,
    required this.dairyFree,
    required this.vegan,
    required this.vegetarian,
    required this.instructions,
    required this.analyzedInstructions,
    // below is temporary variable, will be replaced with
    // userprofile/firebase integration
    required this.extendedIngredients,
    required this.sourceName,
    required this.sourceUrl,
    // requried this.allergens
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        title: json['title'],
        summary: json['summary'],
        readyInMinutes: json['readyInMinutes'],
        image: json['image'],
        servings: json['servings'],
        favorited: false,
        dairyFree: json['dairyFree'],
        vegan: json['vegan'],
        vegetarian: json['vegetarian'],
        instructions: json['instructions'],
        analyzedInstructions: json['analyzedInstructions'],
        extendedIngredients: json['extendedIngredients'],
        sourceName: json['sourceName'],
        sourceUrl: json['sourceUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'readyInMinutes': readyInMinutes,
        'image': image,
        'favorited': favorited,
        'servings': servings,
        'dairyFree': dairyFree,
        'vegan': vegan,
        'vegetarian': vegetarian,
        'extendedIngredients': extendedIngredients,
        'instructions': instructions,
        'analyzedInstructions': analyzedInstructions,
        'sourceName': sourceName,
        'sourceUrl': sourceUrl,
      };
}
