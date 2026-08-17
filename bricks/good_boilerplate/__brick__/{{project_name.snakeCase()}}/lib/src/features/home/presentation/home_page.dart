import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/src/core/ads/ad_mob_banner.dart';
import 'package:{{project_name.snakeCase()}}/src/core/ads/ad_mob_service.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/app_primary_button.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/data/onboarding_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getIt<OnboardingRepository>().markCompleted();
  }

  Future<void> _showInterstitialAd() async {
    final didShow = await getIt<AdMobService>().showInterstitialAd();
    if (!mounted) {
      return;
    }

    _showMessage(
      didShow
          ? 'Interstitial ad shown.'
          : 'Interstitial ad is still loading. Tap again in a moment.',
    );
  }

  Future<void> _showRewardedAd() async {
    final didShow = await getIt<AdMobService>().showRewardedAd(
      onUserEarnedReward: (reward) {
        if (!mounted) {
          return;
        }

        _showMessage('Reward earned: ${reward.amount} ${reward.type}');
      },
    );
    if (!mounted) {
      return;
    }

    if (!didShow) {
      _showMessage('Rewarded ad is still loading. Tap again in a moment.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final config = getIt<AppConfig>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(config.appName)),
      bottomNavigationBar: const SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Center(heightFactor: 1, child: AdMobBanner()),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 28,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Ready to build.',
                              style: textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _InfoPill(label: 'Flavor', value: config.flavor.name),
                      const SizedBox(height: 10),
                      _InfoPill(label: 'App ID', value: config.appId),
                      const SizedBox(height: 10),
                      _InfoPill(
                        label: 'Base API URL',
                        value: config.baseApiUrl,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _HomeActionButton(
                icon: Icons.camera_alt_rounded,
                text: 'Capture Object',
                onPressed: () => context.push(AppRoutes.objectCapture),
              ),
              const SizedBox(height: 12),
              _HomeActionButton(
                icon: Icons.tune_rounded,
                text: 'Open Settings',
                onPressed: () => context.push(AppRoutes.settings),
              ),
              const SizedBox(height: 12),
              _HomeActionButton(
                icon: Icons.ad_units_rounded,
                text: 'Show Interstitial Ad',
                onPressed: _showInterstitialAd,
              ),
              const SizedBox(height: 12),
              _HomeActionButton(
                icon: Icons.card_giftcard_rounded,
                text: 'Show Rewarded Ad',
                onPressed: _showRewardedAd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text.rich(
        TextSpan(
          text: '$label: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  const _HomeActionButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: text,
      icon: icon,
      onPressed: onPressed,
    );
  }
}
