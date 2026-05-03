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
      gemini: GeminiConfig(
        apiKey: 'REPLACE_WITH_GEMINI_PROD_API_KEY',
        prompt: GeminiConfig.defaultPrompt,
      ),
      revenueCat: RevenueCatConfig(
        apiKey: 'REPLACE_WITH_REVENUECAT_PROD_API_KEY',
      ),
      adMob: AdMobConfig(
        bannerAdUnitId: 'ca-app-pub-3940256099942544/6300978111',
        interstitialAdUnitId: 'ca-app-pub-3940256099942544/1033173712',
        rewardedAdUnitId: 'ca-app-pub-3940256099942544/5224354917',
      ),
    ),
  );
}
