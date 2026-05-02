import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/data/onboarding_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getIt<OnboardingRepository>().markCompleted();
  }

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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.settings),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
