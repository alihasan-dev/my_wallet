import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/dashboard/application/bloc/dashboard_event.dart';
import '../../../../features/dashboard/application/bloc/dashboard_state.dart';
import '../../../../features/dashboard/domain/user_model.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/check_connectivity.dart';
import '../../../../utils/preferences.dart';

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
    on<DashboardNameChangeEvent>(_onNameChange);
    on<DashboardDeleteUserEvent>(_onDeleteUser);
    on<DashboardUserDetailsEvent>(_onFetchUserDetails);

    _streamSubscription = firebaseStoreInstance.doc(userId).snapshots().listen((event){
      var userData = event.data() as Map;
      if(userData.isNotEmpty) {
        Preferences.setString(key: AppStrings.prefFullName, value: userData['name']);
        showUnverifiedUser = userData['showUnverified'] ?? true;
        add(DashboardUserDetailsEvent(UserModel(
          name: userData['name'], 
          userId: userData['user_id'], 
          email: userData['email'], 
          phone: userData['phone'],
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
            lastTransactionDate: mapData['lastTransactionTime'] == null ? -1 : mapData['lastTransactionTime'].millisecondsSinceEpoch,
            type: mapData['type'] ?? '',
            isUserVerified: mapData['isVerified'] ?? false
          ));
        }
      }
      originalUserList.sort((a, b) => b.lastTransactionDate.compareTo(a.lastTransactionDate));
      add(DashboardAllUserEvent());
    });

  }

  @override
  Future<void> close() {
    _streamDocumentSnapshot.cancel();
    _streamSubscription.cancel();
    return super.close();
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
    if(await validation(emit, name: event.name, email: event.email)){
      await firebaseStoreInstance.doc(userId).collection('friends').add({
        'name': event.name,
        'email': event.email,
        'phone': '',
        'address': '',
        'profile_img': AppStrings.sampleImg,
        'isVerified': true 
      });
    }
  }


  Future<void> _onDeleteUser(DashboardDeleteUserEvent event, Emitter emit) async {
    await firebaseStoreInstance.doc(userId).collection('friends').doc(event.docId).delete();
  }

  Future<bool> validation(Emitter emit, {required String name, required String email}) async {
    if(name.isBlank){
      emit(DashboardNameFieldState(nameMessage: AppStrings.emptyName));
      return false;
    } else if (email.isEmpty){
      emit(DashboardEmailFieldState(emailMessage: AppStrings.emptyEmail));
      return false;
    } else if (!email.isValidEmail){
      emit(DashboardEmailFieldState(emailMessage: AppStrings.invalidEmail));
      return false;
    } else if (listUser.any((element) => element.email == email)){
      emit(DashboardEmailFieldState(emailMessage: AppStrings.emailAlreadyExist));
      return false;
    } else if (!await checkConnectivity.hasConnection){
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

  void _onNameChange(DashboardNameChangeEvent event, Emitter emit){
    if(event.name.isEmpty){
      emit(DashboardNameFieldState(nameMessage: AppStrings.emptyName));
    } else {
      emit(DashboardNameFieldState(nameMessage: AppStrings.emptyString));
    }
  }

}