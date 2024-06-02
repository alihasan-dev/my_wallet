import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../utils/app_extension_method.dart';
import '../../../../constants/app_strings.dart';
import '../../../../utils/check_connectivity.dart';
import '../../../../utils/preferences.dart';
part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState>{
  
  late CheckConnectivity checkConnectivity;
  late FirebaseAuth authInstance;
  late CollectionReference collectionReference;

  SignupBloc() : super(SignupInitialState()){
    ///create instance of connectivity class;
    authInstance = FirebaseAuth.instance;
    collectionReference = FirebaseFirestore.instance.collection('users');
    checkConnectivity = CheckConnectivity();
    on<SignupSubmitEvent>(onSignupSubmit);
    on<SignupEmailChangeEvent>(_onEmailChange);
    on<SignupNameChangeEvent>(_onNameChange);
    on<SignupPasswordChangeEvent>(_onPasswordChange);
    on<SignupShowPasswordEvent>(_onShowHidePassword);
  }

  Future<void> onSignupSubmit(event, emit) async {
    if(await validation(emit, name: event.name, email: event.email, password: event.password)) {
      ///Show loading dialog
      emit(SignupLoadingState());
      try {
        var userCredential = await authInstance.createUserWithEmailAndPassword(email: event.email, password: event.password);
        var user = userCredential.user;
        if (user != null) {
          Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
          Preferences.setString(key: AppStrings.prefPassword, value: event.password);
          Preferences.setString(key: AppStrings.prefEmail, value: event.email);
          Preferences.setBool(key: AppStrings.prefRememberMe,value: false);
          Preferences.setString(key: AppStrings.prefFullName, value: event.name);
          ///store user in firebase firestore
          await collectionReference.doc(user.uid).set({
            'name': event.name,
            'email': event.email,
            'user_id': user.uid,
            'profile_img': AppStrings.sampleImg
          });
          emit(SignupSuccessState());
        } else {
          emit(SignupFailedState(title: AppStrings.error, message: AppStrings.somethingWentWrong));
        }
      } on FirebaseAuthException catch (e) {
        emit(SignupFailedState(title: AppStrings.failed, message: e.message!));
      }
    }
  }

  void _onEmailChange(event, emit) {
    if(event.email.isEmpty) {
      emit(SignupEmailFieldState(emailMessage: AppStrings.emptyEmail));
    } else  if(!event.email.toString().isValidEmail) {
      emit(SignupEmailFieldState(emailMessage: AppStrings.invalidEmail));
    } else {
      emit(SignupEmailFieldState(emailMessage: AppStrings.emptyString));
    }
  }

  void _onNameChange(event, emit) {
    if(event.name.isEmpty) {
      emit(SignupNameFieldState(nameMessage: AppStrings.emptyName));
    } else {
      emit(SignupNameFieldState(nameMessage: AppStrings.emptyString));
    }
  }

  void _onPasswordChange(event, emit){
    if(event.password.toString().isBlank) {
      emit(SignupPasswordFieldState(passwordMessage: AppStrings.emptyPassword));
    } else  if(event.password.toString().length < 8) {
      emit(SignupPasswordFieldState(passwordMessage: AppStrings.invalidPassword));
    } else {
      emit(SignupPasswordFieldState(passwordMessage: AppStrings.emptyString));
    }
  }

  void _onShowHidePassword(event, emit){
    var temp = event.isVisible ? false : true;
    emit(SignupPasswordVisibilityState(temp));
  }


  Future<bool> validation(Emitter<SignupState> emit, {required String name, required String email, required String password}) async {
    if(name.isBlank) {
      emit(SignupNameFieldState(nameMessage: AppStrings.emptyName));
      return false;
    } else if(email.isBlank) {
      emit(SignupEmailFieldState(emailMessage: AppStrings.emptyEmail));
      return false;
    } else if(!email.isValidEmail) {
      emit(SignupEmailFieldState(emailMessage: AppStrings.invalidEmail));
      return false;
    } else if(password.isBlank) {
      emit(SignupPasswordFieldState(passwordMessage: AppStrings.emptyPassword));
      return false;
    } else if(password.length < 8) {
      emit(SignupPasswordFieldState(passwordMessage: AppStrings.invalidPassword));
      return false;
    } else if(!await checkConnectivity.hasConnection) {
      emit(SignupFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      return false;
    } else {
      return true;
    }
  }
  
}