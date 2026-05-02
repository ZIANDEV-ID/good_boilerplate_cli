class OnboardingSlide {
  const OnboardingSlide({
    required this.logoUrl,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  final String logoUrl;
  final String imageUrl;
  final String title;
  final String subtitle;
}

const defaultOnboardingSlides = [
  OnboardingSlide(
    logoUrl: 'https://placehold.co/96x96/png?text=Logo',
    imageUrl: 'https://placehold.co/720x520/png?text=Slide+1',
    title: 'Build with clarity',
    subtitle: 'A starter foundation with routing, state, DI, and networking ready.',
  ),
  OnboardingSlide(
    logoUrl: 'https://placehold.co/96x96/png?text=Logo',
    imageUrl: 'https://placehold.co/720x520/png?text=Slide+2',
    title: 'Flavor aware',
    subtitle: 'Development and production entry points keep config explicit.',
  ),
  OnboardingSlide(
    logoUrl: 'https://placehold.co/96x96/png?text=Logo',
    imageUrl: 'https://placehold.co/720x520/png?text=Slide+3',
    title: 'Reliable networking',
    subtitle: 'Dio is configured once and can log requests during development.',
  ),
  OnboardingSlide(
    logoUrl: 'https://placehold.co/96x96/png?text=Logo',
    imageUrl: 'https://placehold.co/720x520/png?text=Slide+4',
    title: 'Reusable design',
    subtitle: 'Theme colors and typography are centralized for quick customization.',
  ),
  OnboardingSlide(
    logoUrl: 'https://placehold.co/96x96/png?text=Logo',
    imageUrl: 'https://placehold.co/720x520/png?text=Slide+5',
    title: 'Ready for growth',
    subtitle: 'Feature folders make the next module easy to add and maintain.',
  ),
];
