import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/app_theme.dart';

class {{project_name.pascalCase()}} extends StatelessWidget {
  const {{project_name.pascalCase()}}({
    required this.config,
    super.key,
  });

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: config.isDev,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
      builder: (context, child) {
        if (!config.enableUpgradeCheck) {
          return child ?? const SizedBox.shrink();
        }

        return UpgradeAlert(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
