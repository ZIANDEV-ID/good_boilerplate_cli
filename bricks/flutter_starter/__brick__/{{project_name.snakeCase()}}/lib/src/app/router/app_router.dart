import 'package:go_router/go_router.dart';

import 'package:{{project_name.snakeCase()}}/src/features/home/presentation/home_page.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/presentation/onboarding_page.dart';

abstract final class AppRoutes {
  static const onboarding = '/';
  static const home = '/home';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
