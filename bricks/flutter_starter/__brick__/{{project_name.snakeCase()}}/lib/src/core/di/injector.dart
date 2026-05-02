import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/core/network/dio_factory.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/data/onboarding_repository.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/presentation/cubit/onboarding_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies(AppConfig config) async {
  if (getIt.isRegistered<AppConfig>()) {
    await getIt.reset();
  }

  getIt.registerSingleton<AppConfig>(config);
  getIt.registerLazySingleton<Dio>(() => createDio(config));
  getIt.registerLazySingleton<OnboardingRepository>(
    DefaultOnboardingRepository.new,
  );
  getIt.registerFactory(
    () => OnboardingCubit(getIt<OnboardingRepository>()),
  );
}
