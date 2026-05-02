import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/bootstrap.dart';

void main() {
  bootstrap(
    const AppConfig(
      flavor: AppFlavor.prod,
      appId: '{{app_id}}',
      appName: '{{app_name}}',
      baseApiUrl: 'https://api.example.com',
      enableNetworkLogs: false,
      enableUpgradeCheck: true,
    ),
  );
}
