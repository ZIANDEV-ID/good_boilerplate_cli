enum AppFlavor { dev, prod }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.appId,
    required this.appName,
    required this.baseApiUrl,
    required this.enableNetworkLogs,
    required this.enableUpgradeCheck,
  });

  final AppFlavor flavor;
  final String appId;
  final String appName;
  final String baseApiUrl;
  final bool enableNetworkLogs;
  final bool enableUpgradeCheck;

  bool get isDev => flavor == AppFlavor.dev;
  bool get isProd => flavor == AppFlavor.prod;
}
