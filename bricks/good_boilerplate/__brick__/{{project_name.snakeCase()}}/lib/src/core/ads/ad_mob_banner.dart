import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:{{project_name.snakeCase()}}/src/core/ads/ad_mob_service.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';

class AdMobBanner extends StatefulWidget {
  const AdMobBanner({
    this.size = AdSize.banner,
    super.key,
  });

  final AdSize size;

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    final adMobService = getIt<AdMobService>();
    if (!adMobService.canShowBanner) {
      return;
    }

    _bannerAd = adMobService.createBannerAd(
      size: widget.size,
      onAdLoaded: (_) {
        if (!mounted) {
          return;
        }

        setState(() => _isLoaded = true);
      },
      onAdFailedToLoad: (_, __) {
        if (!mounted) {
          return;
        }

        setState(() => _isLoaded = false);
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerAd = _bannerAd;
    if (!_isLoaded || bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: widget.size.width.toDouble(),
      height: widget.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    );
  }
}
