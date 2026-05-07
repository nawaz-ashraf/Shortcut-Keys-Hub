import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

/// Centralized ad service managing interstitial and rewarded ads.
///
/// Banner and native ads are managed at the widget level via
/// [BannerAdWidget] and [NativeAdWidget].
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _isInterstitialLoading = false;
  bool _isRewardedLoading = false;

  /// Tracks how many times a category has been opened to apply frequency cap.
  int _categoryOpenCount = 0;

  /// Number of category opens between interstitial ads.
  static const int _interstitialFrequency = 3;

  // ─── INITIALIZATION ──────────────────────────────────────────────────

  /// Initialize the Mobile Ads SDK. Call once in main().
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    // Pre-load ads after initialization
    AdService.instance._loadInterstitialAd();
    AdService.instance._loadRewardedAd();
  }

  // ─── INTERSTITIAL ADS ────────────────────────────────────────────────

  void _loadInterstitialAd() {
    if (_isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          debugPrint('[AdService] Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          _isInterstitialLoading = false;
          debugPrint('[AdService] Interstitial failed: ${error.message}');
          // Retry after delay
          Future.delayed(const Duration(seconds: 30), _loadInterstitialAd);
        },
      ),
    );
  }

  /// Call when user opens a category. Shows interstitial every N opens.
  void onCategoryOpened() {
    _categoryOpenCount++;
    if (_categoryOpenCount % _interstitialFrequency == 0) {
      showInterstitialAd();
    }
  }

  /// Show interstitial ad if loaded. Automatically reloads after showing.
  void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (_interstitialAd == null) {
      debugPrint('[AdService] Interstitial not ready');
      onAdDismissed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
        onAdDismissed?.call();
        debugPrint('[AdService] Interstitial show failed: ${error.message}');
      },
    );

    _interstitialAd!.show();
  }

  // ─── REWARDED ADS ────────────────────────────────────────────────────

  void _loadRewardedAd() {
    if (_isRewardedLoading || _rewardedAd != null) return;
    _isRewardedLoading = true;

    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedLoading = false;
          debugPrint('[AdService] Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          _isRewardedLoading = false;
          debugPrint('[AdService] Rewarded failed: ${error.message}');
          Future.delayed(const Duration(seconds: 30), _loadRewardedAd);
        },
      ),
    );
  }

  /// Whether a rewarded ad is ready to show.
  bool get isRewardedAdReady => _rewardedAd != null;

  /// Show a rewarded ad. Calls [onRewarded] when the user earns the reward.
  void showRewardedAd({
    required VoidCallback onRewarded,
    VoidCallback? onAdDismissed,
  }) {
    if (_rewardedAd == null) {
      debugPrint('[AdService] Rewarded not ready');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewardedAd();
        debugPrint('[AdService] Rewarded show failed: ${error.message}');
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        debugPrint('[AdService] User earned reward: ${reward.amount}');
        onRewarded();
      },
    );
  }

  // ─── CLEANUP ─────────────────────────────────────────────────────────

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
