import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
import 'package:{{project_name.snakeCase()}}/src/core/localization/cubit/language_cubit.dart';
import 'package:{{project_name.snakeCase()}}/src/core/localization/generated/app_localizations.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/app_theme.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/cubit/theme_cubit.dart';

class {{project_name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}({required this.config, super.key});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ThemeCubit>()),
        BlocProvider.value(value: getIt<LanguageCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                title: config.appName,
                debugShowCheckedModeBanner: config.isDev,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                locale: locale,
                supportedLocales: AppLanguage.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                routerConfig: appRouter,
                builder: (context, child) {
                  if (!config.enableUpgradeCheck) {
                    return child ?? const SizedBox.shrink();
                  }

                  return UpgradeAlert(child: child ?? const SizedBox.shrink());
                },
              );
            },
          );
        },
      ),
    );
  }
}
