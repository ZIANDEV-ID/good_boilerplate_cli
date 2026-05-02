enum AppFlavor { dev, prod }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appId,
    required this.appName,
    required this.baseApiUrl,
    required this.enableNetworkLogs,
    required this.enableUpgradeCheck,
    this.enableMonetizationServices = true,
    this.revenueCat = const RevenueCatConfig(),
    this.adMob = const AdMobConfig(),
  });

  final AppFlavor flavor;
  final String appId;
  final String appName;
  final String baseApiUrl;
  final bool enableNetworkLogs;
  final bool enableUpgradeCheck;
  final bool enableMonetizationServices;
  final RevenueCatConfig revenueCat;
  final AdMobConfig adMob;

  bool get isDev => flavor == AppFlavor.dev;
  bool get isProd => flavor == AppFlavor.prod;
}

class RevenueCatConfig {
  const RevenueCatConfig({
    this.apiKey = 'REPLACE_WITH_REVENUECAT_API_KEY',
    this.offeringIdentifier = 'default',
  });

  final String apiKey;
  final String offeringIdentifier;

  bool get hasApiKey =>
      apiKey.trim().isNotEmpty && !apiKey.startsWith('REPLACE_WITH_');
}

class AdMobConfig {
  const AdMobConfig({
    this.bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111',
    this.interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712',
    this.rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917',
  });

  final String bannerAdUnitId;
  final String interstitialAdUnitId;
  final String rewardedAdUnitId;

  bool get hasBannerAdUnitId => _hasValue(bannerAdUnitId);
  bool get hasInterstitialAdUnitId => _hasValue(interstitialAdUnitId);
  bool get hasRewardedAdUnitId => _hasValue(rewardedAdUnitId);

  static bool _hasValue(String value) {
    return value.trim().isNotEmpty && !value.startsWith('REPLACE_WITH_');
  }
}
