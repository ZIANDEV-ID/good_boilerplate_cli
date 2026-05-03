import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';
import 'package:{{project_name.snakeCase()}}/src/core/revenuecat/paywall_plan.dart';

class RevenueCatService {
  RevenueCatService();

  RevenueCatConfig? _config;
  bool _isConfigured = false;

  bool get isConfigured => _isConfigured;

  Future<void> configure(RevenueCatConfig config) async {
    _config = config;

    if (!config.hasApiKey) {
      return;
    }

    await Purchases.configure(PurchasesConfiguration(config.apiKey));
    _isConfigured = true;
  }

  Future<Offerings?> getOfferings() async {
    if (!_isConfigured) {
      return null;
    }

    return Purchases.getOfferings();
  }

  Future<Offering?> getDefaultOffering() async {
    final offerings = await getOfferings();
    if (offerings == null) {
      return null;
    }

    final identifier = _config?.offeringIdentifier ?? 'default';
    return offerings.all[identifier] ?? offerings.current;
  }

  Future<List<PaywallPlan>> getPaywallPlans() async {
    if (!_isConfigured) {
      return dummyPaywallPlans;
    }

    final offering = await getDefaultOffering();
    final packages = offering?.availablePackages ?? const <Package>[];

    if (packages.isEmpty) {
      return const <PaywallPlan>[];
    }

    return packages.map(_mapPackageToPlan).toList();
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    if (!_isConfigured) {
      return null;
    }

    return Purchases.getCustomerInfo();
  }

  Future<dynamic> purchasePackage(Package package) async {
    if (!_isConfigured) {
      return null;
    }

    return Purchases.purchase(PurchaseParams.package(package));
  }

  Future<CustomerInfo?> restorePurchases() async {
    if (!_isConfigured) {
      return null;
    }

    return Purchases.restorePurchases();
  }

  PaywallPlan _mapPackageToPlan(Package package) {
    final product = package.storeProduct;
    final introductoryPrice = product.introductoryPrice;
    final hasFreeTrial =
        introductoryPrice != null && introductoryPrice.price == 0;

    return PaywallPlan(
      id: package.identifier,
      title: hasFreeTrial
          ? _trialTitle(introductoryPrice)
          : _packageTitle(package),
      subtitle: hasFreeTrial
          ? 'then ${product.priceString} ${_billingSuffix(package)}'
          : product.priceString,
      badge: package.packageType == PackageType.lifetime ? 'SAVE 80%' : null,
      hasFreeTrial: hasFreeTrial,
      package: package,
    );
  }

  String _trialTitle(IntroductoryPrice introductoryPrice) {
    final units = introductoryPrice.periodNumberOfUnits;
    final label = introductoryPrice.periodUnit.name.toLowerCase();
    return '$units-${_capitalize(label)} Trial';
  }

  String _packageTitle(Package package) {
    return switch (package.packageType) {
      PackageType.lifetime => 'Lifetime',
      PackageType.annual => 'Annual',
      PackageType.sixMonth => '6 Months',
      PackageType.threeMonth => '3 Months',
      PackageType.twoMonth => '2 Months',
      PackageType.monthly => 'Monthly',
      PackageType.weekly => 'Weekly',
      PackageType.custom || PackageType.unknown => package.storeProduct.title,
    };
  }

  String _billingSuffix(Package package) {
    return switch (package.packageType) {
      PackageType.weekly => 'per week',
      PackageType.monthly => 'per month',
      PackageType.annual => 'per year',
      _ => '',
    };
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value.substring(0, 1).toUpperCase() + value.substring(1);
  }
}

const dummyPaywallPlans = [
  PaywallPlan(
    id: 'dummy_lifetime',
    title: 'Lifetime',
    subtitle: 'Rp 349ribu',
    badge: 'SAVE 80%',
  ),
  PaywallPlan(
    id: 'dummy_weekly_trial',
    title: '3-Day Trial',
    subtitle: 'then Rp 69ribu per week',
    hasFreeTrial: true,
  ),
];
