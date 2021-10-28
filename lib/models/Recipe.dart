class Recipe {
  final int id;
  final String title;
  final String summary;
  final int timeEstimate;
  final String imageurl;
  final int servings;
  final String instructions; 

  bool dairyFree;
  bool vegan;
  bool vegetarian;

  final List ingredients;
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
    required this.timeEstimate,
    required this.imageurl,
    required this.servings,
    required this.favorited,
    required this.dairyFree,
    required this.vegan,
    required this.vegetarian,
    required this.instructions,
    required this.analyzedInstructions,
    // below is temporary variable, will be replaced with
    // userprofile/firebase integration
    required this.ingredients,
    required this.sourceName,
    required this.sourceUrl,
    // requried this.allergens
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'],
        title: json['title'],
        summary: json['summary'],
        timeEstimate: json['readyInMinutes'],
        imageurl: json['image'],
        servings: json['servings'],
        favorited: false,
        dairyFree: json['dairyFree'],
        vegan: json['vegan'],
        vegetarian: json['vegetarian'],
        instructions: json['instructions'],
        analyzedInstructions: json['analyzedInstructions'],

        // below is temporary variable, will be replaced with
        // userprofile/firebase integration
        ingredients: json['extendedIngredients'],
        sourceName: json['sourceName'],
        sourceUrl: json['sourceUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'timeEstimate': timeEstimate,
        'imageurl': imageurl,
        'favorited': favorited,
        'servings': servings,
        'dairyFree': dairyFree,
        'vegan': vegan,
        'vegetarian': vegetarian,
        'ingredients': ingredients,
        'instructions': instructions,
        'analyzedInstructions': analyzedInstructions,
        'sourceName': sourceName,
        'sourceUrl': sourceUrl,
      };
}
