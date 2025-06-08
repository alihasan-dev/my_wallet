import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_theme.dart';
import '../features/dashboard/application/bloc/dashboard_bloc.dart';
import '../features/dashboard/application/dashboard_screen.dart';
import '../features/profile/application/bloc/profile_bloc.dart';
import '../features/transaction/application/transaction_details.dart';
import '../features/transaction/application/transaction_sub_details_screen.dart';
import '../widgets/two_column_layout.dart';
import '../features/settings/application/bloc/settings_bloc.dart';
import '../features/settings/application/settings_screen.dart';
import '../features/profile/application/profile_screen.dart';
import '../features/forgot_password/application/bloc/forgot_password_bloc.dart';
import '../features/login/application/bloc/login_bloc.dart';
import '../features/signup/application/bloc/signup_bloc.dart';
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
  static const String transactionDetailsScreen = 'transaction_details';
  static const String forgotPasswordScreen = 'forgotPassword';
  static const String settingsScreen = 'settings';
  static const String profileScreen = 'profile';

  static final GoRouter router = GoRouter(
    observers: [CustomObserver()],
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
        builder: (_, _) => BlocProvider(create: (_) => LoginBloc(), child: const LoginScreen()),
        routes: [
          GoRoute(
            path: forgotPasswordScreen,
            builder: (_, _) => BlocProvider(create: (_) => ForgotPasswordBloc(), child: const ForgotPasswordScreen())
          )
        ]
      ),
      GoRoute(
        path: signupScreen,
        builder: (_, _) => BlocProvider(create: (_) => SignupBloc(), child: const SignupScreen())
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
                path: transactionDetailsScreen,
                pageBuilder: (context, state) { 
                  var data = state.extra == null ? null : state.extra as Map;
                  return defaultPageBuilder(
                    context,
                    state,
                    Preferences.getString(key: AppStrings.prefUserId).isNotEmpty && data != null
                    ? TransactionSubDetailsScreen(
                      transactionBloc: data['transaction_bloc']!,
                      transactionId: data['transaction_id'],
                      title: data['title'],
                    )
                    : const EmptyPage()
                  );
                }
              ),
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
                  var data = state.extra == null ? null : state.extra as Map;
                  return defaultPageBuilder(
                    context,
                    state,
                    Preferences.getString(key: AppStrings.prefUserId).isNotEmpty && data != null
                    ? TransactionDetails(
                        key: Key((data)['user_data'].userId),
                        // key: Key(data as Map ? data.userId : data['user_data'].userId),
                        userModel: (data)['user_data'],
                        dashboardBloc: context.read<DashboardBloc>(),
                      )
                    : const EmptyPage()
                  );
                },
                routes: [
                  GoRoute(
                    path: 'profile',
                    pageBuilder: (context, state) { 
                      var data = state.extra == null ? null : state.extra as Map;
                      return defaultPageBuilder(
                        context,
                        state,
                        BlocProvider(
                          create: (_) => ProfileBloc(friendId: data == null ? '' : data['user_data'].userId),
                          child: ProfileScreen(userId: data == null ? '' : data['user_data'].userId)
                        ),
                      );
                    }
                  ),
                  GoRoute(
                    path: transactionDetailsScreen,
                    pageBuilder: (context, state) { 
                      var data = state.extra == null ? null : state.extra as Map;
                      return defaultPageBuilder(
                        context,
                        state,
                        TransactionSubDetailsScreen(
                          transactionBloc: data!['transaction_bloc']!,
                          transactionId: data['transaction_id'],
                          title: data['title'],
                        )
                      );
                    }
                  )
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

class CustomObserver extends NavigatorObserver {
  @override
  void didChangeTop(Route topRoute, Route? previousTopRoute) {
    if(topRoute.settings.name != null) {
      switch (topRoute.settings.name) {
        case AppRoutes.signupScreen:
          Preferences.setBool(key: AppStrings.prefGoogleSignInFromSignup, value: true);
          break;
        case AppRoutes.loginScreen:
          Preferences.setBool(key: AppStrings.prefGoogleSignInFromSignup, value: false);
          break;
        default:
      }
    }
  }
}