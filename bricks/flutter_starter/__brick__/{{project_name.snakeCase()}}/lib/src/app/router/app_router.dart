import 'package:go_router/go_router.dart';

import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
import 'package:{{project_name.snakeCase()}}/src/features/home/presentation/home_page.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/data/onboarding_repository.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/presentation/onboarding_page.dart';
import 'package:{{project_name.snakeCase()}}/src/features/paywall/presentation/paywall_page.dart';
import 'package:{{project_name.snakeCase()}}/src/features/settings/presentation/settings_page.dart';

abstract final class AppRoutes {
  static const onboarding = '/';
  static const home = '/home';
  static const paywall = '/paywall';
  static const settings = '/settings';
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
      builder: (context, state) => const PaywallPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
