import '../../../../features/dashboard/domain/user_model.dart';

abstract class DashboardState {}

class DashboardInitialState extends DashboardState {}

class DashboardSuccessState extends DashboardState{
  DashboardSuccessState();
}

class DashboardAllUserState extends DashboardState {
  List<UserModel> allUser;
  bool isCancelSearch;
  DashboardAllUserState({required this.allUser, this.isCancelSearch = false});
}

class DashboardFailedState extends DashboardState{
  String message;
  String title;
  DashboardFailedState({required this.message,required this.title});
}

class DashboardLoadingState extends DashboardState{}

class DashboardNameFieldState extends DashboardState{
  String nameMessage;
  DashboardNameFieldState({required this.nameMessage});
}

class DashboardEmailFieldState extends DashboardState{
  String emailMessage;
  DashboardEmailFieldState({required this.emailMessage});
}

class DashboardPasswordFieldState extends DashboardState{
  String passwordMessage;
  DashboardPasswordFieldState({required this.passwordMessage});
}

class DashboardPasswordVisibilityState extends DashboardState{
  bool isVisible;
  DashboardPasswordVisibilityState(this.isVisible);
}