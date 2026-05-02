import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class QuotaRepository {
  final SharedPreferences _prefs;
  static const String _quotaKey = 'daily_quota';
  static const String _lastDateKey = 'last_quota_date';
  static const int maxDailyQuota = 5;

  QuotaRepository(this._prefs);

  Future<void> _resetQuotaIfNewDay() async {
    final lastDate = _prefs.getString(_lastDateKey);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastDate != today) {
      await _prefs.setInt(_quotaKey, maxDailyQuota);
      await _prefs.setString(_lastDateKey, today);
    }
  }

  Future<int> getRemainingQuota() async {
    await _resetQuotaIfNewDay();
    return _prefs.getInt(_quotaKey) ?? maxDailyQuota;
  }

  Future<void> decrementQuota() async {
    final current = await getRemainingQuota();
    if (current > 0) {
      await _prefs.setInt(_quotaKey, current - 1);
    }
  }

  Future<bool> hasQuota() async {
    final current = await getRemainingQuota();
    return current > 0;
  }
}
