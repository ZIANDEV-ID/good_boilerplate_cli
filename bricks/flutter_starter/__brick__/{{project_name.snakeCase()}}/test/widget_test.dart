import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/src/app/app.dart';
import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';

void main() {
  testWidgets('renders onboarding flow', (tester) async {
    const config = AppConfig(
      flavor: AppFlavor.dev,
      appId: '{{app_id}}.dev',
      appName: '{{app_name}} Dev',
      baseApiUrl: 'https://dev-api.example.com',
      enableNetworkLogs: false,
      enableUpgradeCheck: false,
    );

    await configureDependencies(config);
    await tester.pumpWidget(const {{project_name.pascalCase()}}(config: config));

    expect(find.text('Build with clarity'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
