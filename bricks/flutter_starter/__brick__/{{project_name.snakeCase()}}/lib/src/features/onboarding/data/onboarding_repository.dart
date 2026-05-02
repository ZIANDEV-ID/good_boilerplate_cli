import 'package:shared_preferences/shared_preferences.dart';

import 'package:{{project_name.snakeCase()}}/src/features/onboarding/domain/onboarding_slide.dart';

const _onboardingCompletedKey = 'onboarding_completed';

abstract interface class OnboardingRepository {
  List<OnboardingSlide> getSlides();

  bool get isCompleted;

  Future<void> markCompleted();
}

class DefaultOnboardingRepository implements OnboardingRepository {
  DefaultOnboardingRepository(this._preferences);

  final SharedPreferences _preferences;

  @override
  bool get isCompleted => _preferences.getBool(_onboardingCompletedKey) ?? false;

  @override
  List<OnboardingSlide> getSlides() {
    return defaultOnboardingSlides;
  }

  @override
  Future<void> markCompleted() async {
    await _preferences.setBool(_onboardingCompletedKey, true);
  }
}
