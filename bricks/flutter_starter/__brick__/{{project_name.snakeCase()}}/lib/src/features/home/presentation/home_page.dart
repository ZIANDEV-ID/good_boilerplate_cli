import 'package:flutter/material.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = getIt<AppConfig>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(config.appName)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ready to build.',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Flavor: ${config.flavor.name}',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'App ID: ${config.appId}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Base API URL: ${config.baseApiUrl}',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
