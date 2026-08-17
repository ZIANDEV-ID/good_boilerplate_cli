# {{app_name}}

{{description}}

App ID: `{{app_id}}`
Theme style: `{{theme_style}}`

## Getting Started

```sh
flutter pub get
flutter run -t lib/main_dev.dart
flutter run -t lib/main_prod.dart
```

This project includes `android`, `ios`, `web`, and `macos` folders when generated with Mason hooks enabled.

## Monetization

Update `RevenueCatConfig.apiKey` and the `AdMobConfig` ad unit ids in `lib/main_dev.dart` and `lib/main_prod.dart`.
RevenueCat uses `default` for its standard offering and `promo_offer` for its promotional offering. Open `AppRoutes.promoPaywall` to render the promotional paywall.
The paywall uses dummy plans until RevenueCat is configured.

## Feedback

Update `WiredashConfig.projectId` and `WiredashConfig.secret` in both entry points. The Feedback section in Settings opens the Wiredash flow when credentials are configured.

## Code Push

Run `shorebird init` once inside this generated project, set `auto_update: false` in the generated `shorebird.yaml`, then create releases with `shorebird release`. The production flavor checks for and downloads patches after startup; a downloaded patch applies on the next launch.

## Daily Quota

Use `getIt<DailyQuotaService>()` to check or consume per-feature daily limits.

## Code Generation

```sh
dart run build_runner build
```
