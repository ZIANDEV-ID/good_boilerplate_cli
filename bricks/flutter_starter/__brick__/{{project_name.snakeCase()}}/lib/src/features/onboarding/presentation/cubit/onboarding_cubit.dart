import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{project_name.snakeCase()}}/src/features/onboarding/data/onboarding_repository.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/domain/onboarding_slide.dart';

class OnboardingState {
  const OnboardingState({
    required this.slides,
    this.currentIndex = 0,
  });

  final List<OnboardingSlide> slides;
  final int currentIndex;

  bool get isLastSlide => currentIndex == slides.length - 1;

  OnboardingState copyWith({
    List<OnboardingSlide>? slides,
    int? currentIndex,
  }) {
    return OnboardingState(
      slides: slides ?? this.slides,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(OnboardingRepository repository)
      : _repository = repository,
        super(OnboardingState(slides: repository.getSlides()));

  final OnboardingRepository _repository;

  void reload() {
    emit(OnboardingState(slides: _repository.getSlides()));
  }

  void pageChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
