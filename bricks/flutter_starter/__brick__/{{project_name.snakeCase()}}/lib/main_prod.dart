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
      revenueCat: RevenueCatConfig(
        apiKey: 'REPLACE_WITH_REVENUECAT_PROD_API_KEY',
      ),
      adMob: AdMobConfig(
        bannerAdUnitId: 'REPLACE_WITH_PROD_BANNER_AD_UNIT_ID',
        interstitialAdUnitId: 'REPLACE_WITH_PROD_INTERSTITIAL_AD_UNIT_ID',
        rewardedAdUnitId: 'REPLACE_WITH_PROD_REWARDED_AD_UNIT_ID',
      ),
    ),
  );
}
