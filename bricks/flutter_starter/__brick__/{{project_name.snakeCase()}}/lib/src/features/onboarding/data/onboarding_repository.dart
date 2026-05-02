import 'package:{{project_name.snakeCase()}}/src/features/onboarding/domain/onboarding_slide.dart';

abstract interface class OnboardingRepository {
  List<OnboardingSlide> getSlides();
}

class DefaultOnboardingRepository implements OnboardingRepository {
  @override
  List<OnboardingSlide> getSlides() {
    return defaultOnboardingSlides;
  }
}
