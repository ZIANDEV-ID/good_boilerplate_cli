import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/src/core/ads/ad_mob_banner.dart';
import 'package:{{project_name.snakeCase()}}/src/core/ads/ad_mob_service.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
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
              Text('Ready to build.', style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Flavor: ${config.flavor.name}', style: textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text('App ID: ${config.appId}', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(
                'Base API URL: ${config.baseApiUrl}',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.objectCapture),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Capture Object'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.settings),
                child: const Text('Open Settings'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _showInterstitialAd,
                child: const Text('Show Interstitial Ad'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _showRewardedAd,
                child: const Text('Show Rewarded Ad'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
