import 'dart:io';

/// Helper class that provides AdMob ad unit IDs.
///
/// Uses test ad IDs during development. Replace with production IDs before
/// publishing to the Play Store / App Store.
///
/// To find your production ad unit IDs:
///   1. Go to https://apps.admob.com
///   2. Navigate to Apps → Your App → Ad Units
///   3. Copy the ad unit ID for each ad format
class AdHelper {
  // ─── BANNER ──────────────────────────────────────────────────────────
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4392358942856616/8119184278'; // Production
    } else if (Platform.isIOS) {
      // TODO: Replace with your iOS Banner Ad Unit ID
      return 'ca-app-pub-3940256099942544/2934735716'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  // ─── INTERSTITIAL ────────────────────────────────────────────────────
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4392358942856616/3487400586'; // Production
    } else if (Platform.isIOS) {
      // TODO: Replace with your iOS Interstitial Ad Unit ID
      return 'ca-app-pub-3940256099942544/4411468910'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  // ─── REWARDED ────────────────────────────────────────────────────────
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4392358942856616/8356583889'; // Production
    } else if (Platform.isIOS) {
      // TODO: Replace with your iOS Rewarded Ad Unit ID
      return 'ca-app-pub-3940256099942544/1712485313'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  // ─── NATIVE ──────────────────────────────────────────────────────────
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4392358942856616/5538848853'; // Production
    } else if (Platform.isIOS) {
      // TODO: Replace with your iOS Native Ad Unit ID
      return 'ca-app-pub-3940256099942544/3986624511'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }
}
