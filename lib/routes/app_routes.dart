import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/constants/app_theme.dart';
import 'package:my_wallet/features/dashboard/application/bloc/dashboard_bloc.dart';
import 'package:my_wallet/features/dashboard/application/dashboard_screen.dart';
import 'package:my_wallet/features/splash/initial_route.dart';
import 'package:my_wallet/widgets/two_column_layout.dart';
import '../features/settings/application/bloc/settings_bloc.dart';
import '../features/settings/application/settings_screen.dart';
import '../features/profile/application/profile_screen.dart';
import '../features/transaction/application/bloc/transaction_bloc.dart';
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
import '../utils/helper.dart';
import '../utils/preferences.dart';
import '../widgets/empty_page.dart';

class AppRoutes {
  
  AppRoutes._();

  static const String initialRoute = '/';
  static const String loginScreen = '/login';
  static const String signupScreen = '/sign';
  static const String dashboard = '/dashboard';
  static const String transactionScreen = '/transaction';
  static const String forgotPasswordScreen = 'forgotPassword';
  static const String appearanceScreen = '/settings';
  static const String profileScreen = '/profile';

  static final GoRouter router = kIsWeb
  ? webRoutes
  : mobileRoutes;

  static final GoRouter webRoutes = GoRouter(
    redirect: (context, state) {
      var brightness = Theme.of(context).brightness;
      if(brightness == Brightness.dark) {
        Helper.isDark = true;
      } else {
        Helper.isDark = false;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: initialRoute,
        redirect: (context, state) => Preferences.getString(key: AppStrings.prefUserId).isNotEmpty ? dashboard : loginScreen
      ),
      GoRoute(
        path: loginScreen,
        builder: (_, __) => BlocProvider(create: (_) => LoginBloc(), child: const LoginScreen()),
        routes: [
          GoRoute(
            path: forgotPasswordScreen,
            builder: (_, __) => BlocProvider(create: (_) => ForgotPasswordBloc(), child: const ForgotPasswordScreen())
          )
        ]
      ),
      GoRoute(
        path: signupScreen,
        builder: (_, __) => BlocProvider(create: (_) => SignupBloc(), child: const SignupScreen())
      ),
      ShellRoute(
        pageBuilder: (context, state, child) => defaultPageBuilder(
          context,
          state,
          MyAppTheme.isColumnMode(context)
          ? TwoColumnLayout(
              mainView: BlocProvider(create: (_) => DashboardBloc(), child: const DashboardScreen()), 
              sideView: child, 
              displayNavigationRail: false
            )
          : child
        ),
        routes: [
          GoRoute(
            path: dashboard,
            pageBuilder: (context, state) => defaultPageBuilder(
              context,
              state,
              MyAppTheme.isColumnMode(context)
              ? const EmptyPage()
              : BlocProvider(create: (_) => DashboardBloc(), child: const DashboardScreen()),
            ),
            routes: [
              GoRoute(
                path: ':userId',
                pageBuilder: (context, state) {
                  var data = state.extra == null ? null : state.extra as UserModel;
                  return defaultPageBuilder(
                    context,
                    state,
                    BlocProvider(
                      key: Key(data == null ? '' : data.userId),
                      create: (_) => TransactionBloc(
                        userName: data == null ? '' : data.name, 
                        friendId: data == null ? '' : data.userId
                      ), 
                      child: TransactionScreen(userModel: data)
                    ),
                  );
                },
                // redirect: loggedOutRedirect,
              ),
            ]
          ),
        ]
      ),
      // GoRoute(
      //   path: forgotPasswordScreen,
      //   builder: (_, __) => BlocProvider(create: (_) => ForgotPasswordBloc(), child: const ForgotPasswordScreen())
      // ),
      GoRoute(
        path: appearanceScreen,
        builder: (_, state) => BlocProvider(create: (_) => SettingsBloc(), child: const SettingsScreen())
      ),
      GoRoute(
        path: profileScreen,
        builder: (_, state) => ProfileScreen(userId: state.extra as String)
      ),
      GoRoute(
        path: transactionScreen,
        builder: (_, state) {
          var data = state.extra == null ? null : state.extra as UserModel;
          return BlocProvider(
            create: (_) => TransactionBloc(
              userName: data == null ? '' : data.name, 
              friendId: data == null ? '' : data.userId
            ), 
            child: TransactionScreen(userModel: data)
          );
        }
      )
    ],
  );

  static final GoRouter mobileRoutes = GoRouter(
    redirect: (context, state) {
      var brightness = Theme.of(context).brightness;
      if(brightness == Brightness.dark) {
        Helper.isDark = true;
      } else {
        Helper.isDark = false;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: initialRoute,
        builder: (context, state) {
          if(Preferences.getString(key: AppStrings.prefUserId).isNotEmpty) {
            final enableBiometric = Preferences.getBool(key: AppStrings.prefEnableBiometric);
            Preferences.setBool(key: AppStrings.prefBiometricAuthentication, value: enableBiometric);
            return BlocProvider(
              create: (_) => HomeBloc(), 
              child: const HomeScreen()
            );
          } else {
            return BlocProvider(
              create: (_) => LoginBloc(), 
              child: const LoginScreen()
            );
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
        path: dashboard,
        builder: (_, __) => BlocProvider(create: (_) => HomeBloc(), child: const HomeScreen())
      ),
      GoRoute(
        path: forgotPasswordScreen,
        builder: (_, __) => BlocProvider(create: (_) => ForgotPasswordBloc(), child: const ForgotPasswordScreen())
      ),
      GoRoute(
        path: appearanceScreen,
        builder: (_, state) => BlocProvider(create: (_) => SettingsBloc(), child: const SettingsScreen())
      ),
      GoRoute(
        path: profileScreen,
        builder: (_, state) => ProfileScreen(userId: state.extra as String)
      ),
      GoRoute(
        path: transactionScreen,
        builder: (_, state) {
          var data = state.extra == null ? null : state.extra as UserModel;
          return BlocProvider(
            create: (_) => TransactionBloc(
              userName: data == null ? '' : data.name, 
              friendId: data == null ? '' : data.userId
            ), 
            child: TransactionScreen(userModel: data)
          );
        }
      )
    ],
  );


  static Page defaultPageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) =>
      MyAppTheme.isColumnMode(context)
          ? NoTransitionPage(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: child,
            )
          : MaterialPage(
              key: state.pageKey,
              restorationId: state.pageKey.value,
              child: child,
            );

}