sealed class HomeState {}

class HomeInitialState extends HomeState {}

class HomeDrawerItemState extends HomeState {
  int index;
  HomeDrawerItemState({required this.index});
}

class HomeBiometricAuthState extends HomeState {
  bool isAuthenticated;

  HomeBiometricAuthState({this.isAuthenticated = false});
}
