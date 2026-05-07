# AdMob Integration Setup Guide — Shortcut Keys Hub

## Overview

This app uses **Google Mobile Ads SDK** (`google_mobile_ads`) for monetization with four ad formats:
- **Banner Ads** — Home screen bottom, category screen bottom
- **Native Ads** — Between shortcut list items (every ~15 items)
- **Interstitial Ads** — After every 3rd category open
- **Rewarded Ads** — Bonus XP on quiz result screen

---

## Current Status: TEST MODE

All ad unit IDs are currently set to **Google's official test IDs**. These display test ads safely during development.

---

## Production Setup Checklist

### 1. Create AdMob Account
1. Go to [https://apps.admob.com](https://apps.admob.com)
2. Sign in with your Google account
3. Add your app (Android & iOS separately)

### 2. Create Ad Units
Create the following ad units in your AdMob console:

| Ad Format | Android Unit ID | iOS Unit ID |
|-----------|-----------------|-------------|
| Banner | `ca-app-pub-YOUR_ID/XXXXXXXXXX` | `ca-app-pub-YOUR_ID/XXXXXXXXXX` |
| Interstitial | `ca-app-pub-YOUR_ID/XXXXXXXXXX` | `ca-app-pub-YOUR_ID/XXXXXXXXXX` |
| Rewarded | `ca-app-pub-YOUR_ID/XXXXXXXXXX` | `ca-app-pub-YOUR_ID/XXXXXXXXXX` |
| Native | `ca-app-pub-YOUR_ID/XXXXXXXXXX` | `ca-app-pub-YOUR_ID/XXXXXXXXXX` |

### 3. Replace Test IDs

Update the following files with your production IDs:

#### `lib/services/ad_helper.dart`
Replace all test ad unit IDs with your production IDs (look for `TODO` comments).

#### `android/app/src/main/AndroidManifest.xml`
Replace the test Application ID:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-YOUR_PUBLISHER_ID~YOUR_APP_ID"/>
```

#### `ios/Runner/Info.plist`
Replace the test Application ID:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-YOUR_PUBLISHER_ID~YOUR_APP_ID</string>
```

#### `app-ads.txt`
Replace `pub-xxxxxxxxxxxxxxxx` with your actual publisher ID.

### 4. Host app-ads.txt
1. Upload `app-ads.txt` to your developer website root: `https://yourdomain.com/app-ads.txt`
2. Add your website URL in your Play Store listing

---

## Architecture

```
lib/services/
├── ad_helper.dart       # Ad unit IDs (test/production)
└── ad_service.dart      # Singleton managing interstitial & rewarded ads

lib/widgets/
├── banner_ad_widget.dart  # Self-contained banner ad widget
└── native_ad_widget.dart  # Self-contained native ad widget
```

### Key Design Decisions
- **Banner/Native ads** are managed at the widget level (each widget loads its own ad)
- **Interstitial/Rewarded ads** are managed by `AdService` singleton (pre-loaded for instant display)
- **Frequency capping**: Interstitials show every 3rd category open (not every time)
- **Graceful degradation**: All ad widgets show nothing on failure

---

## Testing

### Using Test Ads
The app is pre-configured with Google's test ad unit IDs. Simply run:
```bash
flutter run
```

### Test on Real Device
Test ads only display on real devices or emulators. They will NOT display in Flutter's web mode.

### Verify Production Ads
1. Replace test IDs with production IDs
2. Build a release APK: `flutter build apk --release`
3. Install on a device and verify ads load
4. Monitor the AdMob console for impressions

---

## Common Issues

| Issue | Solution |
|-------|----------|
| Ads not showing | Check internet connection and test on real device |
| "Ad failed to load" | Normal during testing; production ads may take 24h to activate |
| App crashes on startup | Verify APPLICATION_ID in AndroidManifest.xml / Info.plist |
| iOS build fails | Run `cd ios && pod install && cd ..` |
| Banner appears blank | Ensure AdWidget has constrained size |

---

## Policy Compliance

- Privacy policy includes AdMob disclosure ✓
- app-ads.txt file generated ✓
- No ads shown to children under 13 ✓
- Ad frequency is capped to avoid excessive ads ✓
- Ads don't cover content or interfere with navigation ✓
