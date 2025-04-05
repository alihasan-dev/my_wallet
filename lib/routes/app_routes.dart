import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_theme.dart';
import '../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../features/dashboard/application/dashboard_screen.dart';
import '../features/profile/application/bloc/profile_bloc.dart';
import '../features/transaction/application/transaction_details.dart';
import '../widgets/two_column_layout.dart';
import '../features/settings/application/bloc/settings_bloc.dart';
import '../features/settings/application/settings_screen.dart';
import '../features/profile/application/profile_screen.dart';
import '../features/forgot_password/application/bloc/forgot_password_bloc.dart';
import '../features/login/application/bloc/login_bloc.dart';
import '../features/signup/application/bloc/signup_bloc.dart';
import '../features/dashboard/domain/user_model.dart';
import '../features/forgot_password/application/forgot_password_screen.dart';
import '../constants/app_strings.dart';
import '../features/login/application/login_screen.dart';
import '../features/signup/application/signup_screen.dart';
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
  static const String settingsScreen = 'settings';
  static const String profileScreen = 'profile';

  static final GoRouter router = GoRouter(
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
        redirect: (context, state) {
          if(Preferences.getString(key: AppStrings.prefUserId).isEmpty && (state.fullPath == dashboard)) {
            return loginScreen;
          }
          return null;
        },
        pageBuilder: (context, state, child) => defaultPageBuilder(
          context,
          state,
          MyAppTheme.isColumnMode(context)
          ? TwoColumnLayout(
              mainView: BlocProvider(create: (_) => DashboardBloc(), child: DashboardScreen(userId: state.pathParameters['userId'])), 
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
              : BlocProvider(create: (_) => DashboardBloc(), child: DashboardScreen(userId: state.pathParameters['userId'])),
            ),
            routes: [
              GoRoute(
                path: profileScreen,
                pageBuilder: (context, state) { 
                  return defaultPageBuilder(
                    context,
                    state,
                    Preferences.getString(key: AppStrings.prefUserId).isNotEmpty
                    ? const ProfileScreen()
                    : const EmptyPage()
                  );
                }
              ),
              GoRoute(
                path: settingsScreen,
                pageBuilder: (context, state) => defaultPageBuilder(
                  context,
                  state,
                  Preferences.getString(key: AppStrings.prefUserId).isNotEmpty
                  ? BlocProvider(create: (_) => SettingsBloc(), child: const SettingsScreen())
                  : const EmptyPage()
                ),
              ),
              GoRoute(
                path: ':userId',
                redirect: (context, state) => state.extra == null ? dashboard : null,
                pageBuilder: (context, state) {
                  var data = state.extra == null ? null : state.extra as UserModel;
                  return defaultPageBuilder(
                    context,
                    state,
                    Preferences.getString(key: AppStrings.prefUserId).isNotEmpty
                    ? TransactionDetails(
                        key: Key(data == null ? '' : data.userId),
                        userModel: data!,
                        dashboardBloc: context.read<DashboardBloc>(),
                      )
                    : const EmptyPage()
                  );
                },
                routes: [
                  GoRoute(
                    path: 'profile',
                    pageBuilder: (context, state) { 
                      var data = state.extra == null ? null : state.extra as UserModel;
                      return defaultPageBuilder(
                        context,
                        state,
                        BlocProvider(
                          create: (_) => ProfileBloc(friendId: data == null ? '' : data.userId),
                          child: ProfileScreen(userId: data == null ? '' : data.userId)
                        ),
                      );
                    }
                  ),
                ]
              ),
            ]
          ),
        ]
      ),
    ],
  );

  static Page defaultPageBuilder(BuildContext context, GoRouterState state, Widget child) {
    if(MyAppTheme.isColumnMode(context)) {
      return NoTransitionPage(
        key: state.pageKey,
        restorationId: state.pageKey.value,
        child: child,
      );
    }
    return MaterialPage(
      key: state.pageKey,
      restorationId: state.pageKey.value,
      child: child,
    );
  }

}