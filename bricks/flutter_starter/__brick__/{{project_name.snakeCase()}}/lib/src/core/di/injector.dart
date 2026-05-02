import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/core/ads/ad_mob_service.dart';
import 'package:{{project_name.snakeCase()}}/src/core/network/dio_factory.dart';
import 'package:{{project_name.snakeCase()}}/src/core/quota/daily_quota_service.dart';
import 'package:{{project_name.snakeCase()}}/src/core/revenuecat/revenuecat_service.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/cubit/theme_cubit.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/data/onboarding_repository.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/presentation/cubit/onboarding_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies(AppConfig config) async {
  if (getIt.isRegistered<AppConfig>()) {
    await getIt.reset();
  }

  getIt.registerSingleton<AppConfig>(config);
  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<ThemeCubit>(ThemeCubit(preferences));
  getIt.registerSingleton<DailyQuotaService>(DailyQuotaService(preferences));
  getIt.registerLazySingleton<Dio>(() => createDio(config));
  getIt.registerLazySingleton<RevenueCatService>(RevenueCatService.new);
  getIt.registerLazySingleton<AdMobService>(() => AdMobService(config.adMob));
  getIt.registerLazySingleton<OnboardingRepository>(
    () => DefaultOnboardingRepository(preferences),
  );
  getIt.registerFactory(
    () => OnboardingCubit(getIt<OnboardingRepository>()),
  );

  if (config.enableMonetizationServices) {
    await getIt<RevenueCatService>().configure(config.revenueCat);
    await getIt<AdMobService>().initialize();
    await getIt<AdMobService>().loadInterstitialAd();
    await getIt<AdMobService>().loadRewardedAd();
  }
}
