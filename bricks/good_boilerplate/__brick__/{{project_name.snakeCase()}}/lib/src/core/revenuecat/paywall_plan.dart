import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallPlan {
  const PaywallPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    this.badge,
    this.hasFreeTrial = false,
    this.package,
  });

  final String id;
  final String title;
  final String subtitle;
  final String? badge;
  final bool hasFreeTrial;
  final Package? package;

  bool get isDummy => package == null;
}
