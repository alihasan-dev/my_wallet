import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/dashboard/domain/user_model.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/preferences.dart';
import '../../../../utils/check_connectivity.dart';
part 'profile_state.dart';
part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  bool idVisible = false;
  late DocumentReference firebaseDocReference;
  StreamSubscription<QuerySnapshot>? streamSubscriptionFriendList;
  late StreamSubscription<DocumentSnapshot> streamSubscription;
  late Reference firebaseStorage;
  var profileData = <String, dynamic>{};
  late CheckConnectivity checkConnectivity;
  String selectedImagePath = '';
  String friendId;
  List<UserModel> usersList = [];

  ProfileBloc({this.friendId = ''}) : super(ProfileInitialState()) {
    checkConnectivity = CheckConnectivity();
    final userCollectionRef = FirebaseFirestore.instance.collection('users').doc(Preferences.getString(key: AppStrings.prefUserId));
    firebaseDocReference = friendId.isBlank ? userCollectionRef : userCollectionRef.collection('friends').doc(friendId);
    firebaseStorage = FirebaseStorage.instance.ref();

    ///Register Event Here
    on<ProfileUpdateEvent>(_onProfileUpdate);
    on<ProfileShowIdEvent>(_onProfileShowId);
    on<ProfileDataEvent>(_getProfileData);
    on<ProfileNameChangeEvent>(_onNameChange);
    on<ProfilePhoneChangeEvent>(_onPhoneChange);
    on<ProfileEmailChangeEvent>(_onEmailChange);
    on<ProfileChooseImageEvent>(_onChooseImage);
    on<ProfileDeleteUserEvent>(_onDeleteUser);

    if (!friendId.isBlank) {
      streamSubscriptionFriendList = userCollectionRef.collection('friends').snapshots().listen((event) {
        usersList.clear();
        for(var item in event.docs) {
          final user = item.data() as Map;
          if(user.isNotEmpty) {
            usersList.add(UserModel(
              userId: item.id, 
              name: user['name'] ?? '', 
              email: user['email'] ?? '', 
              phone: user['phone'] ?? ''
            ));
          }
        }
      });
    }

    streamSubscription = firebaseDocReference.snapshots().listen((event) { 
      profileData = event.data() as Map<String, dynamic>;
      if(profileData['user_id'] == null) {
        profileData['user_id'] = event.id;
      }
      add(ProfileDataEvent());
    });
    
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    streamSubscriptionFriendList?.cancel();
    return super.close();
  }

  void _onNameChange(ProfileNameChangeEvent event, Emitter emit) {
    if(event.text.isBlank){
      emit(ProfileErrorNameState(message: AppStrings.emptyName));
    } else {
      emit(ProfileErrorNameState(message: AppStrings.emptyString));
    }
  }

  void _onEmailChange(ProfileEmailChangeEvent event, Emitter emit) {
    if (friendId.isNotEmpty && event.email.isBlank) {
      emit(ProfileErrorEmailState(message: AppStrings.emptyString));
      return;
    }
    if(event.email.isBlank) {
      emit(ProfileErrorEmailState(message: AppStrings.emptyEmail));
    } else if(!event.email.isValidEmail) {
      emit(ProfileErrorEmailState(message: AppStrings.invalidEmail));
    } else {
      emit(ProfileErrorEmailState(message: AppStrings.emptyString));
    }
  }

  void _onPhoneChange(ProfilePhoneChangeEvent event, Emitter emit) {
    if (friendId.isBlank && event.text.isBlank) {
      emit(ProfileErrorPhoneState(message: AppStrings.emptyString));
      return;
    }
    if(event.text.length < 10) {
      emit(ProfileErrorPhoneState(message: AppStrings.invalidPhone));
    } else {
      emit(ProfileErrorPhoneState(message: AppStrings.emptyString));
    }
  }

  void _onChooseImage(ProfileChooseImageEvent event, Emitter emit) {
    selectedImagePath = event.imagePath;
    emit(ProfileChooseImageState(imagePath: selectedImagePath));
  }

  Future<void> _onProfileUpdate(ProfileUpdateEvent event, Emitter emit) async {
    if(await fieldValidation(event, emit)) {
      var updatedImageUrl = '';
      if(selectedImagePath.isNotEmpty) {
        emit(ProfileLoadingState());
        try {
          final mountainImagesRef = friendId.isBlank 
          ? firebaseStorage.child("${Preferences.getString(key: AppStrings.prefUserId)}/profile_img.jpg")
          : firebaseStorage.child("${Preferences.getString(key: AppStrings.prefUserId)}/friends/$friendId.jpg");
          await mountainImagesRef.putData(base64Decode(selectedImagePath), SettableMetadata(contentType: 'image/jpeg')).then((value) async {
            await mountainImagesRef.getDownloadURL().then((value) {
              updatedImageUrl = value;
            });
          });
        } catch (e) {
          debugPrint(AppStrings.somethingWentWrong);
        }
      }
      await firebaseDocReference.update({
        'email': event.profileData['email'],
        'name': event.profileData['name'],
        'user_id': event.profileData['user_id'],
        'phone': event.profileData['phone'],
        'address': event.profileData['address'],
        'profile_img': updatedImageUrl.isBlank ? event.profileData['profile_img'] : updatedImageUrl
      });
    }
  }

  Future<void> _onDeleteUser(ProfileDeleteUserEvent event, Emitter emit) async {
    if(event.isConfirmed) {
      emit(ProfileLoadingState());
      await firebaseDocReference.delete();
      emit(ProfileDeleteUserState(isDeleted: true));
    } else {
      emit(ProfileDeleteUserState());
    }
  }

  void _getProfileData(ProfileDataEvent event, Emitter emit) {
    emit(ProfileSuccessState(profileData: profileData));
  }

  void _onProfileShowId(ProfileShowIdEvent event, Emitter emit) {
    idVisible = !idVisible;
    emit(ProfileShowIdState(isIdVisible: idVisible));
  }

  Future<bool> fieldValidation(ProfileUpdateEvent event, Emitter emit) async {
    bool result = true;
    if(event.profileData['user_id'].toString().isBlank) {
      emit(ProfileErrorIdState(message: AppStrings.emptyEmail));
      result = false;
    } 
    if (!event.profileData['email'].toString().isBlank) { 
      if (!event.profileData['email'].toString().isValidEmail) {
        emit(ProfileErrorEmailState(message: AppStrings.invalidEmail));
        result = false;
      }
    }
    if(event.profileData['name'].toString().isBlank) {
      emit(ProfileErrorNameState(message: AppStrings.emptyName));
      result = false;
    } 
    final phone = event.profileData['phone'].toString();
    if (friendId.isBlank && !phone.isBlank) {
      if(phone.length < 10) result = false;
    }
    if (!friendId.isBlank) {
      if (phone.isBlank) {
        result = false;
      } else if (phone.length < 10) {
        result = false;
      } else {
        for (var users in usersList) {
          if (users.userId == friendId) continue;
          if (users.phone == phone) {
            emit(ProfileFailedState(title: AppStrings.phoneNumberAlreadyExist, message: AppStrings.phoneNumberAlreadyExistMsg));
            result = false;
            break;
          }
        }
      }
    }

    if (result && !await checkConnectivity.hasConnection) {
      emit(ProfileFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      result = false;
    } 
    return result;
  }
  
}