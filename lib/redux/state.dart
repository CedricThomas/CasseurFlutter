class ProfileState {
  String name = "";
  String email = "";
  String avatar = "";
}

class AppState {
  bool isAuthenticated = false;
  ProfileState profile = ProfileState();
}