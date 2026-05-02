# flutter_starter

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

A Flutter starter project brick with flavors, routing, Cubit state management, Dio networking, dependency injection, reusable theme tokens, and onboarding.

## Usage

```sh
mason get
mason make flutter_starter
```

## Variables

- `project_name`: Dart package name for the generated project.
- `app_name`: Display name shown in the generated app.
- `org_name`: Organization id reserved for native app ids.
- `description`: Pubspec description.

## Included

- Dev and prod app flavor entry points: `lib/main_dev.dart` and `lib/main_prod.dart`.
- VS Code launch configurations for dev and prod.
- `AppConfig` for per-flavor API base URL, network logging, and upgrade checks.
- Dio with `talker_dio_logger`.
- BLoC Cubit with `flutter_bloc`.
- GoRouter navigation.
- `cached_network_image` wrapper widget.
- `get_it` dependency injection.
- `upgrader` wrapper for app update prompts.
- `json_serializable` and `json_annotation` example model.
- Five-slide onboarding screen with customizable logo, image, title, and subtitle data.
- Reusable theme colors and typography.

[1]: https://github.com/felangel/mason
