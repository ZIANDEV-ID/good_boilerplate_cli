import 'package:flutter/material.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app.dart';
import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies(config);

  runApp({{project_name.pascalCase()}}(config: config));
}
