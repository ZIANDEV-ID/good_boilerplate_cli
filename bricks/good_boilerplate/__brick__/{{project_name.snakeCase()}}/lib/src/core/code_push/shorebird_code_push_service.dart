import 'package:shorebird_code_push/shorebird_code_push.dart';

enum CodePushResult {
  unavailable,
  upToDate,
  downloaded,
  restartRequired,
  failed,
}

class ShorebirdCodePushService {
  ShorebirdCodePushService({ShorebirdUpdater? updater})
    : _updater = updater ?? ShorebirdUpdater();

  final ShorebirdUpdater _updater;

  bool get isAvailable => _updater.isAvailable;

  Future<CodePushResult> checkAndDownloadUpdate() async {
    if (!_updater.isAvailable) {
      return CodePushResult.unavailable;
    }

    try {
      final status = await _updater.checkForUpdate();

      switch (status) {
        case UpdateStatus.outdated:
          await _updater.update();
          return CodePushResult.downloaded;
        case UpdateStatus.restartRequired:
          return CodePushResult.restartRequired;
        case UpdateStatus.upToDate:
          return CodePushResult.upToDate;
        case UpdateStatus.unavailable:
          return CodePushResult.unavailable;
      }
    } on Object {
      return CodePushResult.failed;
    }
  }
}
