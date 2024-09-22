import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/forgot_password/application/bloc/forgot_password_event.dart';
import '../../../../features/forgot_password/application/bloc/forgot_password_state.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/check_connectivity.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState>{

  late CheckConnectivity checkConnectivity;
  late FirebaseAuth _firebaseAuth;
  late CollectionReference _firestoreInstance;
  late StreamSubscription<QuerySnapshot> _streamSubscription;
  List<String> userEmails = [];
  
  ForgotPasswordBloc() : super(ForgotPasswordInitialState()){
    checkConnectivity = CheckConnectivity();
    _firebaseAuth = FirebaseAuth.instance;
    _firestoreInstance = FirebaseFirestore.instance.collection('users');
    on<ForgotPasswordEmailChangeEvent>(_onEmailChange);
    on<ForgotPasswordSubmitEvent>(_onForgotPassword);

    _streamSubscription = _firestoreInstance.snapshots().listen((event) {
      userEmails.clear()
;      for(var item in event.docs) {
        var userData = item.data() as Map;
        if(userData.isNotEmpty) {
          userEmails.add(userData['email']);
        }
      }
    });
  }

  Future<void> _onForgotPassword(ForgotPasswordSubmitEvent event, Emitter emit) async {
    if(await validation(event.email, emit)) {
      emit(ForgotPasswordLoadingState());
      await _firebaseAuth.sendPasswordResetEmail(email: event.email);
      emit(ForgotPasswordSuccessState(message: 'Email has been sent successfully, follow the link and reset your password'));
    }
  }

  Future<bool> validation(String email, Emitter emit) async {
    if(email.isEmpty) {
      emit(ForgotPasswordEmailFieldState(message: AppStrings.emptyEmail));
      return false;
    } else  if(!email.isValidEmail) {
      emit(ForgotPasswordEmailFieldState(message: AppStrings.invalidEmail));
      return false;
    } else if(!userEmails.any((item) => item == email)) {
      emit(ForgotPasswordFailedState(title: 'User does not exist', message: 'User is not registered with this email.'));
      return false;
    } else if(!await checkConnectivity.hasConnection){
      emit(ForgotPasswordFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      return false;
    } else {
      emit(ForgotPasswordEmailFieldState(message: AppStrings.emptyString));
      return true;
    }
  }

  void _onEmailChange(ForgotPasswordEmailChangeEvent event, Emitter emit){
    if(event.value.isEmpty) {
      emit(ForgotPasswordEmailFieldState(message: AppStrings.emptyEmail));
    } else  if(!event.value.toString().isValidEmail) {
      emit(ForgotPasswordEmailFieldState(message: AppStrings.invalidEmail));
    } else {
      emit(ForgotPasswordEmailFieldState(message: AppStrings.emptyString));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}