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
  late StreamSubscription<QuerySnapshot> streamDocumentSnapshot;
  var listUser = <UserModel>[];
  var userId = '';

  DashboardBloc() : super(DashboardInitialState()){
    ///create instance of connectivity class;
    firebaseStoreInstance = FirebaseFirestore.instance.collection('users');
    checkConnectivity = CheckConnectivity();
    userId = Preferences.getString(key: AppStrings.prefUserId);

    on<DashboardAllUserEvent>(_onGetAllUser);
    on<DashboardAddUserEvent>(_onAddUser);
    on<DashboardEmailChangeEvent>(_onEmailChange);
    on<DashboardNameChangeEvent>(_onNameChange);
    on<DashboardDeleteUserEvent>(_onDeleteUser);

    streamDocumentSnapshot = firebaseStoreInstance.doc(userId).collection('friends').snapshots().listen((event) {
      listUser.clear();
      for(var item in event.docs){
        var mapData = item.data();
        if(mapData.isNotEmpty){
          listUser.add(UserModel(
            userId: item.id, 
            name: mapData['name'], 
            email: mapData['email'], 
            phone: mapData['phone'],
            profileImg: mapData['profile_img'] ?? '',
          ));
        }
      }
      add(DashboardAllUserEvent());
    });
  }

  @override
  Future<void> close() {
    streamDocumentSnapshot.cancel();
    return super.close();
  }

  void _onGetAllUser(event, emit) => emit(DashboardAllUserState(allUser: listUser));

  Future<void> _onAddUser(event, emit) async {
    if(await validation(emit, name: event.name, email: event.email)){
      await firebaseStoreInstance.doc(userId).collection('friends').add({
        'name': event.name,
        'email': event.email,
        'phone': '',
        'address': '',
        'profile_img': '',
      });
    }
  }


  Future<void> _onDeleteUser(DashboardDeleteUserEvent event, Emitter emit) async {
    await firebaseStoreInstance.doc(userId).collection('friends').doc(event.docId).delete();
  }

  Future<bool> validation(Emitter<DashboardState> emit, {required String name, required String email}) async {
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

  void _onEmailChange(event, emit) {
    if(event.email.isEmpty){
      emit(DashboardEmailFieldState(emailMessage: AppStrings.emptyEmail));
    } else if(!event.email.toString().isValidEmail){
      emit(DashboardEmailFieldState(emailMessage: AppStrings.invalidEmail));
    } else {
      emit(DashboardEmailFieldState(emailMessage: AppStrings.emptyString));
    }
  }

  void _onNameChange(event, emit){
    if(event.name.isEmpty){
      emit(DashboardNameFieldState(nameMessage: AppStrings.emptyName));
    } else {
      emit(DashboardNameFieldState(nameMessage: AppStrings.emptyString));
    }
  }

}