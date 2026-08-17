enum AppFlavor { dev, prod }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appId,
    required this.appName,
    required this.baseApiUrl,
    required this.enableNetworkLogs,
    required this.enableUpgradeCheck,
    this.enableCodePush = true,
    this.enableMonetizationServices = true,
    this.gemini = const GeminiConfig(),
    this.revenueCat = const RevenueCatConfig(),
    this.adMob = const AdMobConfig(),
    this.wiredash = const WiredashConfig(),
  });

  final AppFlavor flavor;
  final String appId;
  final String appName;
  final String baseApiUrl;
  final bool enableNetworkLogs;
  final bool enableUpgradeCheck;
  final bool enableCodePush;
  final bool enableMonetizationServices;
  final GeminiConfig gemini;
  final RevenueCatConfig revenueCat;
  final AdMobConfig adMob;
  final WiredashConfig wiredash;

  bool get isDev => flavor == AppFlavor.dev;
  bool get isProd => flavor == AppFlavor.prod;
}

class GeminiConfig {
  const GeminiConfig({
    this.apiKey = 'REPLACE_WITH_GEMINI_API_KEY',
    this.model = 'gemini-2.5-flash',
    this.baseUrl = 'https://generativelanguage.googleapis.com',
    this.prompt = defaultPrompt,
  });

  static const defaultPrompt = '''
Analyze the object in this image.
Return a concise, useful result in the same language as the user interface if possible.
Describe:
1. The main object.
2. Visible condition or notable details.
3. Practical uses or next actions.
Keep the answer under 120 words.
''';

  final String apiKey;
  final String model;
  final String baseUrl;
  final String prompt;

  bool get hasApiKey =>
      apiKey.trim().isNotEmpty && !apiKey.startsWith('REPLACE_WITH_');
}

class RevenueCatConfig {
  const RevenueCatConfig({
    this.apiKey = 'REPLACE_WITH_REVENUECAT_API_KEY',
    this.offeringIdentifier = 'default',
    this.promoOfferingIdentifier = 'promo_offer',
  });

  final String apiKey;
  final String offeringIdentifier;
  final String promoOfferingIdentifier;

  bool get hasApiKey =>
      apiKey.trim().isNotEmpty && !apiKey.startsWith('REPLACE_WITH_');
}

class WiredashConfig {
  const WiredashConfig({
    this.projectId = 'REPLACE_WITH_WIREDASH_PROJECT_ID',
    this.secret = 'REPLACE_WITH_WIREDASH_SECRET',
  });

  final String projectId;
  final String secret;

  bool get hasCredentials => _hasValue(projectId) && _hasValue(secret);

  static bool _hasValue(String value) {
    return value.trim().isNotEmpty && !value.startsWith('REPLACE_WITH_');
  }
}

class AdMobConfig {
  const AdMobConfig({
    this.bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111',
    this.interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712',
    this.rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917',
    this.testDeviceIds = const ['A4354D827D54EE6B948B1E10DE27C195'],
  });

  final String bannerAdUnitId;
  final String interstitialAdUnitId;
  final String rewardedAdUnitId;
  final List<String> testDeviceIds;

  bool get hasBannerAdUnitId => _hasValue(bannerAdUnitId);
  bool get hasInterstitialAdUnitId => _hasValue(interstitialAdUnitId);
  bool get hasRewardedAdUnitId => _hasValue(rewardedAdUnitId);

  static bool _hasValue(String value) {
    return value.trim().isNotEmpty && !value.startsWith('REPLACE_WITH_');
  }
}
