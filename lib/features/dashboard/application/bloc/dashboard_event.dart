import 'package:my_wallet/features/dashboard/domain/user_model.dart';

abstract class DashboardEvent {}

class DashboardInitialEvent extends DashboardEvent {}


class DashboardAllUserEvent extends DashboardEvent {}

class DashboardNameChangeEvent extends DashboardEvent {
  String name;
  DashboardNameChangeEvent({required this.name});
}

class DashboardEmailChangeEvent extends DashboardEvent {
  String email;
  DashboardEmailChangeEvent({required this.email});
}

class DashboardAddUserEvent extends DashboardEvent {
  String name;
  String email;
  DashboardAddUserEvent({required this.name, required this.email});
}

class DashboardDeleteUserEvent extends DashboardEvent {
  String docId;
  DashboardDeleteUserEvent({required this.docId});
}

class DashboardUserDetailsEvent extends DashboardEvent {
  UserModel userModel;

  DashboardUserDetailsEvent(this.userModel);
}