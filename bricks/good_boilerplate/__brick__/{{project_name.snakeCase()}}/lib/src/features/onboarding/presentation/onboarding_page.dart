import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:{{project_name.snakeCase()}}/src/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/domain/onboarding_slide.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/presentation/widgets/onboarding_illustration.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OnboardingCubit>(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final slide = state.slides[state.currentIndex];

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                children: [
                  OnboardingStepper(
                    itemCount: state.slides.length,
                    currentIndex: state.currentIndex,
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.slides.length,
                      onPageChanged: context
                          .read<OnboardingCubit>()
                          .pageChanged,
                      itemBuilder: (context, index) {
                        return OnboardingSlideContent(
                          slide: state.slides[index],
                        );
                      },
                    ),
                  ),
                  OnboardingPrimaryButton(
                    text: slide.buttonText,
                    onPressed: () {
                     if (state.isLastSlide) {
                        context.go(AppRoutes.paywall);
                        return;
                      }

                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TrustedInfo(text: slide.trustedInfo),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OnboardingStepper extends StatelessWidget {
  const OnboardingStepper({
    required this.itemCount,
    required this.currentIndex,
    super.key,
  });

  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        children: List.generate(itemCount * 2 - 1, (index) {
          if (index.isOdd) {
            final lineIndex = index ~/ 2;
            final isActive = lineIndex < currentIndex;

            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }

          final dotIndex = index ~/ 2;
          final isActive = dotIndex <= currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : const Color(0xFFF3F3F3),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}

class OnboardingSlideContent extends StatelessWidget {
  const OnboardingSlideContent({required this.slide, super.key});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxHeight < 520;
        final topSpacing = isCompact
            ? (constraints.maxHeight * 0.03).clamp(8.0, 18.0)
            : (constraints.maxHeight * 0.13).clamp(38.0, 104.0);
        final imageHeight = isCompact
            ? (constraints.maxHeight * 0.28).clamp(104.0, 160.0)
            : (constraints.maxHeight * 0.36).clamp(190.0, 320.0);
        final imageTopSpacing = isCompact
            ? (constraints.maxHeight * 0.04).clamp(12.0, 22.0)
            : (constraints.maxHeight * 0.14).clamp(38.0, 120.0);

        return Column(
          children: [
            SizedBox(height: topSpacing),
            OnboardingHeadline(
              text: slide.headline,
              fontSize: isCompact ? 24 : 28,
            ),
            SizedBox(height: isCompact ? 10 : 20),
            OnboardingSubheadline(
              text: slide.subheadline,
              fontSize: isCompact ? 14 : 16,
            ),
            SizedBox(height: imageTopSpacing),
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: OnboardingIllustration(type: slide.illustrationType),
            ),
          ],
        );
      },
    );
  }
}

class OnboardingHeadline extends StatelessWidget {
  const OnboardingHeadline({
    required this.text,
    required this.fontSize,
    super.key,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
    );
  }
}

class OnboardingSubheadline extends StatelessWidget {
  const OnboardingSubheadline({
    required this.text,
    required this.fontSize,
    super.key,
  });

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        height: 1.35,
      ),
    );
  }
}

class OnboardingPrimaryButton extends StatelessWidget {
  const OnboardingPrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: Colors.black.withValues(alpha: 0.24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class TrustedInfo extends StatelessWidget {
  const TrustedInfo({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
