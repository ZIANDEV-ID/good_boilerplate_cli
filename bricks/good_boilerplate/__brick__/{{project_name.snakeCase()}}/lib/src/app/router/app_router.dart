import 'package:go_router/go_router.dart';

import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
import 'package:{{project_name.snakeCase()}}/src/features/home/presentation/home_page.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/data/onboarding_repository.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/presentation/onboarding_page.dart';
import 'package:{{project_name.snakeCase()}}/src/features/paywall/presentation/paywall_page.dart';
import 'package:{{project_name.snakeCase()}}/src/features/settings/presentation/settings_page.dart';
import 'package:{{project_name.snakeCase()}}/src/features/object_capture/presentation/pages/object_capture_page.dart';
import 'package:{{project_name.snakeCase()}}/src/features/object_capture/presentation/cubit/object_capture_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract final class AppRoutes {
  static const onboarding = '/';
  static const home = '/home';
  static const paywall = '/paywall';
  static const promoPaywall = '/paywall?promo=true';
  static const settings = '/settings';
  static const objectCapture = '/object-capture';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  redirect: (context, state) {
    final isOpeningOnboarding = state.matchedLocation == AppRoutes.onboarding;
    final onboardingCompleted = getIt<OnboardingRepository>().isCompleted;

    if (isOpeningOnboarding && onboardingCompleted) {
      return AppRoutes.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.paywall,
      builder: (context, state) => PaywallPage(
        usePromoOffering: state.uri.queryParameters['promo'] == 'true',
      ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.objectCapture,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<ObjectCaptureCubit>()..init(),
        child: const ObjectCapturePage(),
      ),
    ),
  ],
);
