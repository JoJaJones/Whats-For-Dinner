/// *******************************************************************
/// Singleton to manage the User and allow access from any screen of
/// the app. Will also load the user info from firebase when the app is
/// booted (if user is logged in) or upon user log in
///*******************************************************************/
class UserManager {
  static final UserManager _userManager = UserManager._internal();
  //todo replace these with firebase user
  final String imagePath =
      "https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1387&q=80";
  final String name = "John Smith";
  final String email = "example@example.com";

  UserManager._internal() {
    // Todo read from firebase DB and load user with contained data
    // Todo Move authentication and firebase user logic here
  }

  factory UserManager() {
    return _userManager;
  }
}
