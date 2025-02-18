import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  LoginBloc() : super(LoginInitialState()){
    authInstance = FirebaseAuth.instance;
    checkConnectivity = CheckConnectivity();
    on<LoginSubmitEvent>(_onLoginSubmit);
    on<LoginEmailChangeEvent>(_onEmailChange);
    on<LoginPasswordChangeEvent>(_onPasswordChange);
    on<LoginShowPasswordEvent>(_onShowHidePassword);
    on<LoginRememberMeEvent>(_onRememberMe);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
  }

  Future<void> _onLoginWithGoogle(LoginWithGoogleEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      const List<String> scopes = ['email'];
      final googleSignIn = GoogleSignIn(scopes: scopes);
      final accountData = await googleSignIn.signInSilently();
      if(accountData != null) {
        final displayName = accountData.displayName ?? '';
        final email = accountData.email;
        final id = accountData.id;
        final photoUrl = accountData.photoUrl;
        final googleSignInAuthentication = await accountData.authentication;
        final authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken
        );
        final firebaseUserCredential = await authInstance.signInWithCredential(authCredential);
        final user = firebaseUserCredential.user;
        if (user != null) {
          firebaseDocumentReference = FirebaseFirestore.instance.collection('users').doc(user.uid);
          Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
          Preferences.setString(key: AppStrings.prefEmail, value: email);
          await firebaseDocumentReference.get().then((data) {
            var mapData = data.data() as Map;
            if(mapData.isNotEmpty) {
              Preferences.setBool(key: AppStrings.prefEnableBiometric, value: mapData['enableBiometric'] ?? false);
            }
          });
          emit(LoginSuccessState());
        } else {
          emit(LoginFailedState(title: AppStrings.error, message: AppStrings.somethingWentWrong));
        }
      }
    } catch (e) {
      emit(LoginFailedState(title: AppStrings.failed, message: 'Google authentication failed, please try again.'));
    }
  }

  Future<void> _onLoginSubmit(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    if(await validation(emit, email: event.email, password: event.password)) {
      emit(LoginLoadingState());
      try {
        var userCredential = await authInstance.signInWithEmailAndPassword(email: event.email, password: event.password);
        var user = userCredential.user;
        if (user != null) {
          firebaseDocumentReference = FirebaseFirestore.instance.collection('users').doc(user.uid);
          Preferences.setString(key: AppStrings.prefUserId, value: user.uid);
          Preferences.setString(key: AppStrings.prefEmail, value: event.email);
          Preferences.setBool(key: AppStrings.prefRememberMe,value: event.isRememberMe);
          if(event.isRememberMe) {
            Preferences.setString(key: AppStrings.prefPassword, value: event.password);
          }
          await firebaseDocumentReference.get().then((data) {
            var mapData = data.data() as Map;
            if(mapData.isNotEmpty) {
              Preferences.setBool(key: AppStrings.prefEnableBiometric, value: mapData['enableBiometric'] ?? false);
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

  void _onRememberMe(LoginRememberMeEvent event, Emitter emit) => emit(LoginRememberMeState(event.value));

  void _onEmailChange(LoginEmailChangeEvent event, Emitter emit) {
    if(event.email.isEmpty) {
      emit(LoginEmailFieldState(emailMessage: AppStrings.emptyEmail));
    } else  if(!event.email.toString().isValidEmail) {
      emit(LoginEmailFieldState(emailMessage: AppStrings.invalidEmail));
    } else {
      emit(LoginEmailFieldState(emailMessage: AppStrings.emptyString));
    }
  }

  void _onPasswordChange(LoginPasswordChangeEvent event, Emitter emit) {
    if(event.password.toString().isBlank) {
      emit(LoginPasswordFieldState(passwordMessage: AppStrings.emptyPassword));
    } else {
      emit(LoginPasswordFieldState(passwordMessage: AppStrings.emptyString));
    }
  }

  //method used to show and hide password
  void _onShowHidePassword(LoginShowPasswordEvent event, Emitter emit){
    emit(LoginPasswordVisibilityState(!event.isVisible));
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
    } else if(!await checkConnectivity.hasConnection) {
      emit(LoginFailedState(title: AppStrings.noInternetConnection, message: AppStrings.noInternetConnectionMessage));
      return false;
    } else {
      return true;
    }
  }

}