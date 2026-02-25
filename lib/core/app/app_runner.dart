import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:new_mshwar_app_customer/core/di/di.dart';
import 'package:new_mshwar_app_customer/core/localization/locale_cubit.dart';
import 'package:new_mshwar_app_customer/core/localization/supported_locales.dart';
import 'package:new_mshwar_app_customer/core/theme/theme_cubit.dart';
import 'package:new_mshwar_app_customer/core/theme/app_theme.dart';
import 'package:new_mshwar_app_customer/core/routing/app_router.dart';
import 'package:new_mshwar_app_customer/core/routing/routes.dart';
import 'package:new_mshwar_app_customer/core/routing/navigation_service.dart';
import 'package:new_mshwar_app_customer/core/widgets/app_snackbar.dart';

/// ─────────────────────────────────────────────────────────────
/// Root widget — wires BlocProviders, Theme, Locale, and Router.
///
/// Call this from your main.dart:
///   void main() async {
///     await AppInitializer.init(env: Environment.dev);
///     runApp(const AppRunner());
///   }
/// ─────────────────────────────────────────────────────────────
class AppRunner extends StatelessWidget {
  const AppRunner({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                title: 'Mshwar',
                debugShowCheckedModeBanner: false,

                // ── Theme ──
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeState.mode,

                // ── Locale ──
                locale: localeState.locale,
                supportedLocales: SupportedLocales.all,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                // ── Navigation ──
                navigatorKey: NavigationService.navigatorKey,
                scaffoldMessengerKey: AppSnackbar.messengerKey,
                initialRoute: Routes.splash,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
