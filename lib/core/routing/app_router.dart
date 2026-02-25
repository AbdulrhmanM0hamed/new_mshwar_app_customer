import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_mshwar_app_customer/core/constants/durations.dart';
import 'package:new_mshwar_app_customer/core/di/di.dart';
import 'package:new_mshwar_app_customer/core/routing/routes.dart';
import 'package:new_mshwar_app_customer/core/utils/logger.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/pages/login_page.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/pages/phone_login_page.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/pages/register_page.dart';
import 'package:new_mshwar_app_customer/feature/auth/presentation/pages/forgot_password_page.dart';
import 'package:new_mshwar_app_customer/feature/splash/presentation/pages/splash_page.dart';
import 'package:new_mshwar_app_customer/shared/widgets/bottom_nav_shell.dart';

/// ─────────────────────────────────────────────────────────────
/// Centralised route generator.
///
/// Feed this to [MaterialApp.onGenerateRoute].
/// ─────────────────────────────────────────────────────────────
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    AppLogger.navigation('→ ${settings.name} | args: ${settings.arguments}');

    switch (settings.name) {
      // ── Splash ──
      case Routes.splash:
        return _page(const SplashPage(), settings);

      // ── Auth ──
      case Routes.login:
        return _page(
          BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const LoginPage(),
          ),
          settings,
        );

      case Routes.otp:
        return _page(
          BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const PhoneLoginPage(),
          ),
          settings,
        );

      case Routes.register:
        return _page(
          BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const RegisterPage(),
          ),
          settings,
        );

      case Routes.forgotPassword:
        return _page(
          BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const ForgotPasswordPage(),
          ),
          settings,
        );

      // ── Home (Bottom Nav Shell) ──
      case Routes.home:
        return _page(const BottomNavShell(), settings);

      default:
        return _page(_UnknownRoutePage(settings.name), settings);
    }
  }

  /// Standard [MaterialPageRoute].
  static MaterialPageRoute<T> _page<T>(Widget page, RouteSettings settings) {
    return MaterialPageRoute<T>(builder: (_) => page, settings: settings);
  }

  /// Slide‑from‑right transition.
  static PageRouteBuilder<T> slideRoute<T>(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: AppDurations.pageTransition,
      reverseTransitionDuration: AppDurations.pageTransition,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        );
      },
    );
  }
}

/// Fallback page for unregistered routes.
class _UnknownRoutePage extends StatelessWidget {
  final String? routeName;
  const _UnknownRoutePage(this.routeName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text(
          'No route defined for: $routeName',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
