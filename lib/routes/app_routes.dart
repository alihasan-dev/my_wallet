import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/forgot_password/application/bloc/forgot_password_bloc.dart';
import '../features/home/application/bloc/home_bloc.dart';
import '../features/login/application/bloc/login_bloc.dart';
import '../features/signup/application/bloc/signup_bloc.dart';
import '../features/dashboard/domain/user_model.dart';
import '../features/forgot_password/application/forgot_password_screen.dart';
import '../features/home/application/home_screen.dart';
import '../constants/app_strings.dart';
import '../features/login/application/login_screen.dart';
import '../features/signup/application/signup_screen.dart';
import '../features/transaction/application/transaction_screen.dart';
import '../utils/preferences.dart';

class AppRoutes {

  AppRoutes._();

  static const String initialRoute = '/';
  static const String loginScreen = '/login_screen';
  static const String signupScreen = '/sign_up_screen';
  static const String homeScreen = '/home_screen';
  static const String transactionScreen = '/transaction_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: initialRoute,
        builder: (_, __) {
          if(Preferences.getString(key: AppStrings.prefUserId).isNotEmpty) {
            Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: true);
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        }
      ),
      GoRoute(
        path: loginScreen,
        builder: (_, __) => BlocProvider(create: (_) => LoginBloc(), child: const LoginScreen())
      ),
      GoRoute(
        path: signupScreen,
        builder: (_, __) => BlocProvider(create: (_) => SignupBloc(), child: const SignupScreen())
      ),
      GoRoute(
        path: homeScreen,
        builder: (_, __) => BlocProvider(create: (_) => HomeBloc(), child: const HomeScreen())
      ),
      GoRoute(
        path: forgotPasswordScreen,
        builder: (_, __) => BlocProvider(create: (_) => ForgotPasswordBloc(), child: const ForgotPasswordScreen())
      ),
      GoRoute(
        path: transactionScreen,
        builder: (_, state) {
          var data = state.extra as UserModel;
          return TransactionScreen(userModel: data);
        }
      ),
    ],
  );

}