import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/dashboard/domain/user_model.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/check_connectivity.dart';
import '../../../../utils/preferences.dart';
part 'dashboard_state.dart';
part 'dashboard_event.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  late CheckConnectivity checkConnectivity;
  late CollectionReference firebaseInstane;
  late CollectionReference firebaseStoreInstance;
  late StreamSubscription<QuerySnapshot> _streamDocumentSnapshot;
  late StreamSubscription<DocumentSnapshot> _streamSubscription;
  var listUser = <UserModel>[];
  var originalUserList = <UserModel>[];
  String userId = '';
  bool showUnverifiedUser = true;

  DashboardBloc() : super(DashboardInitialState()) {
    firebaseStoreInstance = FirebaseFirestore.instance.collection('users');
    checkConnectivity = CheckConnectivity();
    userId = Preferences.getString(key: AppStrings.prefUserId);

    on<DashboardAllUserEvent>(_onGetAllUser);
    on<DashboardAddUserEvent>(_onAddUser);
    on<DashboardEmailChangeEvent>(_onEmailChange);
    on<DashboardPhoneChangeEvent>(_onPhoneChange);
    on<DashboardNameChangeEvent>(_onNameChange);
    on<DashboardDeleteUserEvent>(_onDeleteUser);
    on<DashboardUserDetailsEvent>(_onFetchUserDetails);
    on<DashboardSearchEvent>(_onSearchEvent);
    on<DashboardSelectedUserEvent>(_onSelectedUserEvent);
    on<DashboardSearchFieldEnableEvent>(_onSearchFieldEnableEvent);
    on<DashboardSelectedContactEvent>(_onSelectContactEvent);
    on<DashboardCancelSelectedContactEvent>(_onCancelSelectedContactEvent);
    on<DashboardPinnedContactEvent>(_onPinnedContact);
    on<DashboardBiometricAuthEvent>(_onBiometricAuthenticated);

    _streamSubscription = firebaseStoreInstance.doc(userId).snapshots().listen((event) {
      var userData = event.data() as Map;
      if(userData.isNotEmpty) {
        Preferences.setString(key: AppStrings.prefFullName, value: userData['name']);
        showUnverifiedUser = userData['showUnverified'] ?? true;
        add(DashboardUserDetailsEvent(UserModel(
          name: userData['name'],
          userId: userData['user_id'],
          email: userData['email'],
          phone: userData['phone'] ?? '',
          isUserVerified: userData['showUnverified'] ?? true
        )));
      }
    });

    _streamDocumentSnapshot = firebaseStoreInstance.doc(userId).collection('friends').snapshots().listen((event) async {
      originalUserList.clear();
      for(var item in event.docs) {
        var mapData = item.data();
        if(mapData.isNotEmpty) {
          originalUserList.add(UserModel(
            userId: item.id, 
            name: mapData['name'], 
            email: mapData['email'], 
            phone: mapData['phone'],
            profileImg: mapData['profile_img'] ?? '',
            amount: mapData['amount'] ?? '',
            lastTransactionDate: mapData['lastTransactionTime'] == null
            ? -1
            : mapData['lastTransactionTime'].millisecondsSinceEpoch,
            type: mapData['type'] ?? '',
            isUserVerified: mapData['isVerified'] ?? false,
            isPinned: mapData['pinned'] ?? false
          ));
        }
      }
      originalUserList.sort((a, b) => b.lastTransactionDate.compareTo(a.lastTransactionDate));
      originalUserList.sort((a, b) => a.isPinned ? -1 : (b.isPinned ? 1 : 0));
      add(DashboardAllUserEvent());
    });
  }

  @override
  Future<void> close() {
    _streamDocumentSnapshot.cancel();
    _streamSubscription.cancel();
    return super.close();
  }

  void _onBiometricAuthenticated(DashboardBiometricAuthEvent event, Emitter emit) {
    emit(DashboardBiometricAuthState(isAuthenticated: event.isAuthenticated));
  }

  Future<void> _onPinnedContact(DashboardPinnedContactEvent event, Emitter emit) async {
    if(listUser.isNotEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      for(int i = 0; i < listUser.length; i++) {
        if(listUser[i].isSelected) {
          final docReference = firebaseStoreInstance.doc(userId).collection('friends').doc(listUser[i].userId);
          batch.update(docReference, {'pinned': !listUser[i].isPinned});
          listUser[i].isSelected = false;
        }
      }
      batch.commit();
    }
  }

  void _onCancelSelectedContactEvent(DashboardCancelSelectedContactEvent event, Emitter emit) {
    for(int i = 0; i < listUser.length; i++) {
      listUser[i].isSelected = false;
    }
    emit(DashboardAllUserState(allUser: listUser));
  }

  void _onSelectContactEvent(DashboardSelectedContactEvent event, Emitter emit) {
    if(listUser.isNotEmpty) {
      for(int i = 0; i < listUser.length; i++) {
        if(listUser[i].userId == event.selectedUserId) {
          listUser[i].isSelected = !listUser[i].isSelected;
        }
      }
      emit(DashboardAllUserState(allUser: listUser));
    }
  }

  void _onSearchFieldEnableEvent(DashboardSearchFieldEnableEvent event, Emitter emit) {
    if(event.isSearchFieldClosed) {
      listUser.clear();
      if(showUnverifiedUser) {
        listUser.addAll(originalUserList);
      } else {
        listUser.addAll(originalUserList.where((item) => item.isUserVerified));
      }
      emit(DashboardAllUserState(allUser: listUser, isCancelSearch: true));
    } else {
      emit(DashboardSearchFieldEnableState());
    }
  }

  void _onSelectedUserEvent(DashboardSelectedUserEvent event, Emitter emit) {
    emit(DashboardSelectedUserState(userId: event.userId));
  }

  void _onSearchEvent(DashboardSearchEvent event, Emitter emit) {
    if(originalUserList.isNotEmpty) {
      listUser.clear();
      if(event.text.isEmpty) {
        if(showUnverifiedUser) {
          listUser.addAll(originalUserList);
        } else {
          listUser.addAll(originalUserList.where((item) => item.isUserVerified));
        }
      } else {
        for(var item in originalUserList) {
          final isMatchingName = item.name.toLowerCase().contains(event.text.toLowerCase());
          final shouldAddUser = (showUnverifiedUser || (!showUnverifiedUser && item.isUserVerified));
          if (isMatchingName && shouldAddUser) {
            listUser.add(item);
          }
        }
      }
      emit(DashboardAllUserState(allUser: listUser));
    }
  }

  void _onFetchUserDetails(DashboardUserDetailsEvent event, Emitter emit) {
    if(originalUserList.isNotEmpty) {
      listUser.clear();
      if(showUnverifiedUser) {
        listUser.addAll(originalUserList);
      } else {
        listUser.addAll(originalUserList.where((item) => item.isUserVerified));
      }
      emit(DashboardAllUserState(allUser: listUser));
    }
  }

  void _onGetAllUser(event, emit) {
    listUser.clear();
    if(showUnverifiedUser) {
      listUser.addAll(originalUserList);
    } else {
      listUser.addAll(originalUserList.where((item) => item.isUserVerified));
    }
    emit(DashboardAllUserState(allUser: listUser));
  }

  Future<void> _onAddUser(DashboardAddUserEvent event, Emitter emit) async {
    if(await validation(emit, name: event.name, email: event.email, phone: event.phone)) {
      await firebaseStoreInstance.doc(userId).collection('friends').add({
        'name': event.name,
        'email': event.email,
        'phone': event.phone,
        'address': '',
        'profile_img': AppStrings.sampleImg,
        'isVerified': true 
      });
    }
  }

  Future<void> _onDeleteUser(DashboardDeleteUserEvent event, Emitter emit) async {
    await firebaseStoreInstance.doc(userId).collection('friends').doc(event.docId).delete();
  }

  Future<bool> validation(Emitter emit, {required String name, String email = '', required String phone}) async {
    if(name.isBlank) {
      emit(DashboardNameFieldState(nameMessage: AppStrings.emptyName));
      return false;
    } else if (phone.isEmpty) {
      emit(DashboardPhoneFieldState(phoneMessage: AppStrings.emptyPhone));
      return false;
    } else if (!phone.isValidPhone) {
      emit(DashboardPhoneFieldState(phoneMessage: AppStrings.invalidPhone));
      return false;
    } else if (listUser.any((element) => element.phone == phone)) {
      emit(DashboardPhoneFieldState(phoneMessage: AppStrings.phoneAlreadyExist));
      return false;
    } else if (!await checkConnectivity.hasConnection) {
      emit(DashboardFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      return false;
    }
    return true;
  }

  void _onEmailChange(DashboardEmailChangeEvent event, Emitter emit) {
    if(event.email.isEmpty){
      emit(DashboardEmailFieldState(emailMessage: AppStrings.emptyEmail));
    } else if(!event.email.toString().isValidEmail){
      emit(DashboardEmailFieldState(emailMessage: AppStrings.invalidEmail));
    } else {
      emit(DashboardEmailFieldState(emailMessage: AppStrings.emptyString));
    }
  }

  void _onPhoneChange(DashboardPhoneChangeEvent event, Emitter emit) {
    if(event.phone.isEmpty) {
      emit(DashboardPhoneFieldState(phoneMessage: AppStrings.emptyPhone));
    } else if(!event.phone.isValidPhone) {
      emit(DashboardPhoneFieldState(phoneMessage: AppStrings.invalidPhone));
    } else {
      emit(DashboardPhoneFieldState(phoneMessage: AppStrings.emptyString));
    }
  }

  void _onNameChange(DashboardNameChangeEvent event, Emitter emit){
    if(event.name.isEmpty){
      emit(DashboardNameFieldState(nameMessage: AppStrings.emptyName));
    } else {
      emit(DashboardNameFieldState(nameMessage: AppStrings.emptyString));
    }
  }

}