import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/src/app/app.dart';
import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders onboarding flow', (tester) async {
    SharedPreferences.setMockInitialValues({});

    const config = AppConfig(
      flavor: AppFlavor.dev,
      appId: '{{app_id}}.dev',
      appName: '{{app_name}} Dev',
      baseApiUrl: 'https://dev-api.example.com',
      enableNetworkLogs: false,
      enableUpgradeCheck: false,
      enableMonetizationServices: false,
    );

    await configureDependencies(config);
    await tester.pumpWidget(const {{project_name.pascalCase()}}(config: config));

    expect(find.text('Powerful Sound\nFrequencies'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Trusted by 104626+ users'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
