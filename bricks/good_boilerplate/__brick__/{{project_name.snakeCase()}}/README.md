# {{app_name}}

{{description}}

App ID: `{{app_id}}`

## Getting Started

```sh
flutter pub get
flutter run -t lib/main_dev.dart
flutter run -t lib/main_prod.dart
```

This project includes `android`, `ios`, `web`, and `macos` folders when generated with Mason hooks enabled.

## Monetization

Update `RevenueCatConfig.apiKey` and the `AdMobConfig` ad unit ids in `lib/main_dev.dart` and `lib/main_prod.dart`.
RevenueCat uses offering identifier `default`.
The paywall uses dummy plans until RevenueCat is configured.

## Daily Quota

Use `getIt<DailyQuotaService>()` to check or consume per-feature daily limits.

## Code Generation

```sh
dart run build_runner build
```
