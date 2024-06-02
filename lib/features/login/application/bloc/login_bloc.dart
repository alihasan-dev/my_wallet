import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../utils/check_connectivity.dart';
import '../../../../utils/preferences.dart';
part 'login_event.dart';
part 'login_state.dart';

///The business logic layer's responsibilities is to respond to input from the presentation layer with new states.
///This layer can depend on one or more repositories to reterieve data needed to build up the aplication state.
///
///Business logic layer as the bridge between the user interface (presentation layer) and the data layer.
///Business logic layer is notified of events/actions from the presentation layer and then communicates with 
///repository in order to build a new state for the presentation layer to consume.

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  late CheckConnectivity checkConnectivity;
  late FirebaseAuth authInstance;
  late DocumentReference firebaseDocumentReference;

  LoginBloc() : super(LoginInitialState()) {
    authInstance = FirebaseAuth.instance;
    checkConnectivity = CheckConnectivity();
    on<LoginSubmitEvent>(_onLoginSubmit);
    on<LoginEmailChangeEvent>(_onEmailChange);
    on<LoginPasswordChangeEvent>(_onPasswordChange);
    on<LoginShowPasswordEvent>(_onShowHidePassword);
    on<LoginRememberMeEvent>(_onRememberMe);
  }

  Future<void> _onLoginSubmit(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    if(await validation(emit, email: event.email, password: event.password)){
      emit(LoginLoadingState());
      try {
        var userCredential = await authInstance.signInWithEmailAndPassword(email: event.email, password: event.password);
        var user = userCredential.user;
        if (user != null) {
          firebaseDocumentReference = FirebaseFirestore.instance.collection('users').doc(user.uid);
          Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
          Preferences.setString(key: AppStrings.prefEmail, value: event.email);
          Preferences.setBool(key: AppStrings.prefRememberMe,value: event.isRememberMe);
          if(event.isRememberMe){
            Preferences.setString(key: AppStrings.prefPassword, value: event.password);
          }
          await firebaseDocumentReference.get().then((data){
            var mapData = data.data() as Map;
            if(mapData.isNotEmpty){
              Preferences.setString(key: AppStrings.prefFullName, value: mapData['name']);
            }
          });
          emit(LoginSuccessState());
        } else {
          emit(LoginFailedState(title: AppStrings.error, message: AppStrings.somethingWentWrong));
        }
      } on FirebaseAuthException catch (e) {
        emit(LoginFailedState(title: AppStrings.failed, message: e.message!));
      }
    }
  }

  void _onRememberMe(event, emit) => emit(LoginRememberMeState(event.value));

  void _onEmailChange(event, emit) {
    if(event.email.isEmpty) {
      emit(LoginEmailFieldState(emailMessage: AppStrings.emptyEmail));
    } else  if(!event.email.toString().isValidEmail) {
      emit(LoginEmailFieldState(emailMessage: AppStrings.invalidEmail));
    } else {
      emit(LoginEmailFieldState(emailMessage: AppStrings.emptyString));
    }
  }

  void _onPasswordChange(event, emit) {
    if(event.password.toString().isBlank){
      emit(LoginPasswordFieldState(passwordMessage: AppStrings.emptyPassword));
    } else  if(event.password.toString().length < 8){
      emit(LoginPasswordFieldState(passwordMessage: AppStrings.invalidPassword));
    } else {
      emit(LoginPasswordFieldState(passwordMessage: AppStrings.emptyString));
    }
  }

  //method used to show and hide password
  void _onShowHidePassword(event, emit) {
    var temp = event.isVisible ? false : true;
    emit(LoginPasswordVisibilityState(temp));
  }

  ///this method is used to validate the email and password field
  Future<bool> validation(Emitter<LoginState> emit, {required String email, required String password}) async {
    if(email.isBlank) {
      emit(LoginEmailFieldState(emailMessage: AppStrings.emptyEmail));
      return false;
    } else if(!email.isValidEmail) {
      emit(LoginEmailFieldState(emailMessage: AppStrings.invalidEmail));
      return false;
    } else if(password.isBlank) {
      emit(LoginPasswordFieldState(passwordMessage: AppStrings.emptyPassword));
      return false;
    } else if(password.length < 8) {
      emit(LoginPasswordFieldState(passwordMessage: AppStrings.invalidPassword));
      return false;
    } else if(!await checkConnectivity.hasConnection) {
      emit(LoginFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      return false;
    } else {
      return true;
    }
  }

}