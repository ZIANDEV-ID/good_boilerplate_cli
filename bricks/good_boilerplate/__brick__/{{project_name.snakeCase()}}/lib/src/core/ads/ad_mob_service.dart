import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';

class AdMobService {
  AdMobService(this._config);

  final AdMobConfig _config;
  bool _isInitialized = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool get isInitialized => _isInitialized;
  bool get canShowBanner => _config.hasBannerAdUnitId;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      if (_config.testDeviceIds.isNotEmpty) {
        await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: _config.testDeviceIds),
        );
      }
      await MobileAds.instance.initialize();
      _isInitialized = true;
    } catch (error, stackTrace) {
      debugPrint('AdMob initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  BannerAd createBannerAd({
    AdSize size = AdSize.banner,
    AdRequest request = const AdRequest(),
    void Function(Ad ad)? onAdLoaded,
    void Function(Ad ad, LoadAdError error)? onAdFailedToLoad,
  }) {
    if (!_config.hasBannerAdUnitId) {
      throw StateError('Banner ad unit id has not been configured.');
    }

    return BannerAd(
      adUnitId: _config.bannerAdUnitId,
      size: size,
      request: request,
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onAdFailedToLoad?.call(ad, error);
        },
      ),
    )..load();
  }

  Future<void> loadInterstitialAd({
    AdRequest request = const AdRequest(),
  }) async {
    if (!_config.hasInterstitialAdUnitId) {
      return;
    }

    try {
      await InterstitialAd.load(
        adUnitId: _config.interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (error) {
            debugPrint('Interstitial failed to load: $error');
            _interstitialAd = null;
          },
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Interstitial load failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<bool> showInterstitialAd() async {
    final ad = _interstitialAd;
    if (ad == null) {
      await loadInterstitialAd();
      return false;
    }

    _interstitialAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial failed to show: $error');
        ad.dispose();
        loadInterstitialAd();
      },
    );
    ad.show();
    return true;
  }

  Future<void> loadRewardedAd({AdRequest request = const AdRequest()}) async {
    if (!_config.hasRewardedAdUnitId) {
      return;
    }

    try {
      await RewardedAd.load(
        adUnitId: _config.rewardedAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) => _rewardedAd = ad,
          onAdFailedToLoad: (error) {
            debugPrint('Rewarded failed to load: $error');
            _rewardedAd = null;
          },
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Rewarded load failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<bool> showRewardedAd({
    required void Function(RewardItem reward) onUserEarnedReward,
  }) async {
    final ad = _rewardedAd;
    if (ad == null) {
      await loadRewardedAd();
      return false;
    }

    _rewardedAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Rewarded failed to show: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );
    ad.show(onUserEarnedReward: (_, reward) => onUserEarnedReward(reward));
    return true;
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
