enum OnboardingIllustrationType { soundWave, phonePatterns, speakerTest }

class OnboardingSlide {
  const OnboardingSlide({
    required this.headline,
    required this.subheadline,
    required this.illustrationType,
    this.buttonText = 'Continue',
    this.trustedInfo = 'Trusted by 104626+ users',
  });

  final String headline;
  final String subheadline;
  final OnboardingIllustrationType illustrationType;
  final String buttonText;
  final String trustedInfo;
}

const defaultOnboardingSlides = [
  OnboardingSlide(
    headline: 'Powerful Sound\nFrequencies',
    subheadline:
        'Use specially calibrated tones to effectively eject water from your phone speakers.',
    illustrationType: OnboardingIllustrationType.soundWave,
  ),
  OnboardingSlide(
    headline: 'Multiple Eject\nPatterns',
    subheadline:
        'Choose from various sound patterns optimized for different speaker types.',
    illustrationType: OnboardingIllustrationType.phonePatterns,
  ),
  OnboardingSlide(
    headline: 'Test Your Speakers',
    subheadline:
        'Check speaker health with stereo tests and custom tone generation.',
    illustrationType: OnboardingIllustrationType.speakerTest,
  ),
];
