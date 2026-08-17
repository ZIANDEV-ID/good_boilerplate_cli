import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/bootstrap.dart';

void main() {
  bootstrap(
    const AppConfig(
      flavor: AppFlavor.dev,
      appId: '{{app_id}}.dev',
      appName: '{{app_name}} Dev',
      baseApiUrl: 'https://dev-api.example.com',
      enableNetworkLogs: true,
      enableUpgradeCheck: true,
      enableCodePush: false,
      gemini: GeminiConfig(
        apiKey: 'REPLACE_WITH_GEMINI_DEV_API_KEY',
        prompt: GeminiConfig.defaultPrompt,
      ),
      revenueCat: RevenueCatConfig(
        apiKey: 'REPLACE_WITH_REVENUECAT_DEV_API_KEY',
        offeringIdentifier: 'default',
        promoOfferingIdentifier: 'promo_offer',
      ),
      wiredash: WiredashConfig(
        projectId: 'REPLACE_WITH_WIREDASH_DEV_PROJECT_ID',
        secret: 'REPLACE_WITH_WIREDASH_DEV_SECRET',
      ),
      adMob: AdMobConfig(
        bannerAdUnitId: 'ca-app-pub-3940256099942544/6300978111',
        interstitialAdUnitId: 'ca-app-pub-3940256099942544/1033173712',
        rewardedAdUnitId: 'ca-app-pub-3940256099942544/5224354917',
      ),
    ),
  );
}
