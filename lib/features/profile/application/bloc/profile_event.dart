part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class ProfileUpdateEvent extends ProfileEvent {
  Map<String, dynamic> profileData;
  ProfileUpdateEvent({required this.profileData});
}

class ProfileShowIdEvent extends ProfileEvent {}

class ProfileDataEvent extends ProfileEvent {}

class ProfileNameChangeEvent extends ProfileEvent {
  String text;
  ProfileNameChangeEvent({required this.text});
}

class ProfilePhoneChangeEvent extends ProfileEvent {
  String text;
  ProfilePhoneChangeEvent({required this.text});
}


class ProfileChooseImageEvent extends ProfileEvent {
  String imagePath;
  ProfileChooseImageEvent({required this.imagePath});
}

class ProfileDeleteUserEvent extends ProfileEvent {
  bool isConfirmed;
  ProfileDeleteUserEvent({this.isConfirmed = false});
}