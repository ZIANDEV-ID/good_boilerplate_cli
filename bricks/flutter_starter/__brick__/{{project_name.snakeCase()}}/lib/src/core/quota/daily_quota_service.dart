import 'package:shared_preferences/shared_preferences.dart';

class DailyQuotaService {
  DailyQuotaService(this._preferences);

  final SharedPreferences _preferences;

  Future<DailyQuotaState> getUsage({
    required String featureKey,
    required int dailyLimit,
    DateTime? now,
  }) async {
    final usage = _readUsage(featureKey: featureKey, now: now);
    return DailyQuotaState(
      featureKey: featureKey,
      dailyLimit: dailyLimit,
      used: usage.used,
      dateKey: usage.dateKey,
    );
  }

  Future<bool> canConsume({
    required String featureKey,
    required int dailyLimit,
    int amount = 1,
    DateTime? now,
  }) async {
    final state = await getUsage(
      featureKey: featureKey,
      dailyLimit: dailyLimit,
      now: now,
    );

    return state.used + amount <= dailyLimit;
  }

  Future<DailyQuotaState> consume({
    required String featureKey,
    required int dailyLimit,
    int amount = 1,
    DateTime? now,
  }) async {
    if (amount < 1) {
      throw ArgumentError.value(amount, 'amount', 'must be greater than 0');
    }

    final usage = _readUsage(featureKey: featureKey, now: now);
    final nextUsed = (usage.used + amount).clamp(0, dailyLimit).toInt();

    await _preferences.setString(_dateStorageKey(featureKey), usage.dateKey);
    await _preferences.setInt(_usedStorageKey(featureKey), nextUsed);

    return DailyQuotaState(
      featureKey: featureKey,
      dailyLimit: dailyLimit,
      used: nextUsed,
      dateKey: usage.dateKey,
    );
  }

  Future<DailyQuotaState> reset({
    required String featureKey,
    required int dailyLimit,
    DateTime? now,
  }) async {
    final dateKey = _dateKey(now ?? DateTime.now());

    await _preferences.setString(_dateStorageKey(featureKey), dateKey);
    await _preferences.setInt(_usedStorageKey(featureKey), 0);

    return DailyQuotaState(
      featureKey: featureKey,
      dailyLimit: dailyLimit,
      used: 0,
      dateKey: dateKey,
    );
  }

  _DailyQuotaUsage _readUsage({
    required String featureKey,
    DateTime? now,
  }) {
    final currentDateKey = _dateKey(now ?? DateTime.now());
    final storedDateKey = _preferences.getString(_dateStorageKey(featureKey));

    if (storedDateKey != currentDateKey) {
      return _DailyQuotaUsage(dateKey: currentDateKey, used: 0);
    }

    return _DailyQuotaUsage(
      dateKey: currentDateKey,
      used: _preferences.getInt(_usedStorageKey(featureKey)) ?? 0,
    );
  }

  String _dateKey(DateTime dateTime) {
    final local = dateTime.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _dateStorageKey(String featureKey) {
    return 'daily_quota.$featureKey.date';
  }

  String _usedStorageKey(String featureKey) {
    return 'daily_quota.$featureKey.used';
  }
}

class DailyQuotaState {
  const DailyQuotaState({
    required this.featureKey,
    required this.dailyLimit,
    required this.used,
    required this.dateKey,
  });

  final String featureKey;
  final int dailyLimit;
  final int used;
  final String dateKey;

  int get remaining => (dailyLimit - used).clamp(0, dailyLimit).toInt();
  bool get isLimitReached => used >= dailyLimit;
}

class _DailyQuotaUsage {
  const _DailyQuotaUsage({
    required this.dateKey,
    required this.used,
  });

  final String dateKey;
  final int used;
}
