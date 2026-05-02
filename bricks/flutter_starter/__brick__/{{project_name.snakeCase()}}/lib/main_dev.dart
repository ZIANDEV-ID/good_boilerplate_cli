import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/bootstrap.dart';

void main() {
  bootstrap(
    const AppConfig(
      flavor: AppFlavor.dev,
      appName: '{{app_name}} Dev',
      baseApiUrl: 'https://dev-api.example.com',
      enableNetworkLogs: true,
      enableUpgradeCheck: true,
    ),
  );
}
