# good_boilerplate_cli

Mason workspace for generating Flutter starter projects.

## Setup

```sh
dart pub global activate mason_cli
mason get
```

## Generate a Starter

```sh
mason make flutter_starter
```

The `flutter_starter` brick provides a ready baseline that can be expanded with native platform flavor settings when bundle ids, schemes, and app icons are finalized.

## Current Starter Features

- Dev and prod flavor entry points.
- VS Code launch configurations for dev and prod.
- Per-flavor config for app name, base API URL, network logging, and upgrade checks.
- Dio, Talker Dio logger, Flutter Bloc/Cubit, GoRouter, cached network images, GetIt, Upgrader.
- Json Serializable setup with an example model.
- Five-slide onboarding data that can customize logo, image, title, and subtitle.
- Reusable theme colors and typography.
