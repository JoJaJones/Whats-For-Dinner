/// *******************************************************************
/// Singleton to manage the User and allow access from any screen of
/// the app. Will also load the user info from firebase when the app is
/// booted (if user is logged in) or upon user log in
///*******************************************************************/
class FavoritesManager {
  static final FavoritesManager _favoritesManager =
      FavoritesManager._internal();
  static const USER_COLLECTION = "Favorites";

  FavoritesManager._internal() {
    //Todo
  }

  factory FavoritesManager() {
    return _favoritesManager;
  }
}
