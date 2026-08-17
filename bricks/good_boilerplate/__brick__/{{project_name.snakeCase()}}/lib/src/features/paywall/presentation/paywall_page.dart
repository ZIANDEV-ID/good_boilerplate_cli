import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
import 'package:{{project_name.snakeCase()}}/src/core/revenuecat/paywall_plan.dart';
import 'package:{{project_name.snakeCase()}}/src/core/revenuecat/revenuecat_service.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/app_primary_button.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({this.usePromoOffering = false, super.key});

  static const privacyPolicyUrl = 'https://example.com/privacy-policy';
  static const termsOfUseUrl = 'https://example.com/terms-of-use';

  final bool usePromoOffering;

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  late final Future<List<PaywallPlan>> _plansFuture;
  bool _freeTrialEnabled = true;
  String? _selectedPlanId;

  @override
  void initState() {
    super.initState();
    _plansFuture = getIt<RevenueCatService>().getPaywallPlans(
      promotional: widget.usePromoOffering,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaywallColors.background,
      body: SafeArea(
        child: FutureBuilder<List<PaywallPlan>>(
          future: _plansFuture,
          builder: (context, snapshot) {
            final revenueCatService = getIt<RevenueCatService>();
            final plans =
                snapshot.data ??
                (revenueCatService.isConfigured
                    ? const <PaywallPlan>[]
                    : dummyPaywallPlans);

            if (plans.isEmpty) {
              return PaywallUnavailableContent(
                isLoading: snapshot.connectionState == ConnectionState.waiting,
                onClose: _close,
                onRestore: _restore,
                onTerms: () => _openUrl(PaywallPage.termsOfUseUrl),
                onPrivacy: () => _openUrl(PaywallPage.privacyPolicyUrl),
              );
            }

            final selectedPlanId = _selectedPlanId ?? _defaultPlanId(plans);
            final selectedPlan = plans.firstWhere(
              (plan) => plan.id == selectedPlanId,
              orElse: () => plans.first,
            );

            return PaywallContent(
              plans: plans,
              selectedPlanId: selectedPlanId,
              freeTrialEnabled: _freeTrialEnabled,
              isLoading: snapshot.connectionState == ConnectionState.waiting,
              onClose: _close,
              onPlanSelected: _selectPlan,
              onFreeTrialChanged: (value) {
                _setFreeTrialEnabled(value, plans);
              },
              onContinue: () => _continue(selectedPlan),
              onRestore: _restore,
              onTerms: () => _openUrl(PaywallPage.termsOfUseUrl),
              onPrivacy: () => _openUrl(PaywallPage.privacyPolicyUrl),
            );
          },
        ),
      ),
    );
  }

  String _defaultPlanId(List<PaywallPlan> plans) {
    if (_freeTrialEnabled) {
      final trialPlans = plans.where((plan) => plan.hasFreeTrial);
      if (trialPlans.isNotEmpty) {
        return trialPlans.first.id;
      }
    }

    return plans.first.id;
  }

  void _selectPlan(PaywallPlan plan) {
    setState(() {
      _selectedPlanId = plan.id;
      _freeTrialEnabled = plan.hasFreeTrial;
    });
  }

  void _setFreeTrialEnabled(bool value, List<PaywallPlan> plans) {
    setState(() {
      _freeTrialEnabled = value;
      final matchingPlans = plans.where(
        (plan) => value ? plan.hasFreeTrial : !plan.hasFreeTrial,
      );
      if (matchingPlans.isNotEmpty) {
        _selectedPlanId = matchingPlans.first.id;
      }
    });
  }

  Future<void> _continue(PaywallPlan plan) async {
    final package = plan.package;
    if (package == null) {
      _showMessage('Dummy plan aktif. Isi RevenueCat API key untuk pembelian.');
      return;
    }

    await getIt<RevenueCatService>().purchasePackage(package);

    if (!mounted) {
      return;
    }

    _showMessage('Purchase flow selesai.');
  }

  Future<void> _restore() async {
    final customerInfo = await getIt<RevenueCatService>().restorePurchases();

    if (!mounted) {
      return;
    }

    final message = customerInfo == null
        ? 'RevenueCat belum dikonfigurasi.'
        : 'Purchase berhasil direstore.';
    _showMessage(message);
  }

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go('/home');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class PaywallUnavailableContent extends StatelessWidget {
  const PaywallUnavailableContent({
    required this.isLoading,
    required this.onClose,
    required this.onRestore,
    required this.onTerms,
    required this.onPrivacy,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onClose;
  final VoidCallback onRestore;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: DelayedCloseButton(onClose: onClose),
          ),
          const Spacer(),
          const PaywallHero(),
          const SizedBox(height: 24),
          if (isLoading)
            const CircularProgressIndicator(color: PaywallColors.primary)
          else ...[
            const Text(
              'Plans unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PaywallColors.text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'RevenueCat is configured, but no packages were found in the selected offering.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PaywallColors.mutedText,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          const Spacer(),
          PaywallFooterLinks(
            onRestore: onRestore,
            onTerms: onTerms,
            onPrivacy: onPrivacy,
          ),
        ],
      ),
    );
  }
}

class PaywallContent extends StatelessWidget {
  const PaywallContent({
    required this.plans,
    required this.selectedPlanId,
    required this.freeTrialEnabled,
    required this.isLoading,
    required this.onClose,
    required this.onPlanSelected,
    required this.onFreeTrialChanged,
    required this.onContinue,
    required this.onRestore,
    required this.onTerms,
    required this.onPrivacy,
    super.key,
  });

  final List<PaywallPlan> plans;
  final String selectedPlanId;
  final bool freeTrialEnabled;
  final bool isLoading;
  final VoidCallback onClose;
  final ValueChanged<PaywallPlan> onPlanSelected;
  final ValueChanged<bool> onFreeTrialChanged;
  final VoidCallback onContinue;
  final VoidCallback onRestore;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: DelayedCloseButton(onClose: onClose),
          ),
          const SizedBox(height: 20),
          const PaywallHero(),
          const SizedBox(height: 16),
          const PaywallBenefitList(
            benefits: [
              PaywallBenefit(
                icon: Icons.speed_rounded,
                title: 'Turbo Eject Pattern',
              ),
              PaywallBenefit(
                icon: Icons.all_inclusive_rounded,
                title: 'Unlimited Ejects',
              ),
              PaywallBenefit(icon: Icons.block_rounded, title: 'No Ads'),
              PaywallBenefit(
                icon: Icons.lock_outline_rounded,
                title: 'No Annoying Paywalls',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isLoading) const LinearProgressIndicator(minHeight: 2),
                  PaywallPlanList(
                    plans: plans,
                    selectedPlanId: selectedPlanId,
                    onPlanSelected: onPlanSelected,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          PaywallTrialSwitch(
            value: freeTrialEnabled,
            onChanged: onFreeTrialChanged,
          ),
          const SizedBox(height: 16),
          PaywallContinueButton(
            text: freeTrialEnabled ? 'Try for Free' : 'Continue',
            onPressed: onContinue,
          ),
          const SizedBox(height: 16),
          PaywallFooterLinks(
            onRestore: onRestore,
            onTerms: onTerms,
            onPrivacy: onPrivacy,
          ),
        ],
      ),
    );
  }
}

class DelayedCloseButton extends StatefulWidget {
  const DelayedCloseButton({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  State<DelayedCloseButton> createState() => _DelayedCloseButtonState();
}

class _DelayedCloseButtonState extends State<DelayedCloseButton> {
  bool _canClose = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.92, end: 1).animate(animation),
              child: child,
            ),
          );
        },
        child: _canClose
            ? IconButton(
                key: const ValueKey('close'),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close_rounded, size: 18),
                color: PaywallColors.close,
                onPressed: widget.onClose,
              )
            : Center(
                key: const ValueKey('progress'),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(seconds: 5),
                  onEnd: () {
                    if (mounted) {
                      setState(() => _canClose = true);
                    }
                  },
                  builder: (context, value, child) {
                    return SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 1.6,
                        color: PaywallColors.primary,
                        backgroundColor: PaywallColors.cardBorder,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

class PaywallHero extends StatelessWidget {
  const PaywallHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(
            Icons.volume_up_outlined,
            color: PaywallColors.primary,
            size: 52,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Unlimited Access',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: PaywallColors.text,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class PaywallBenefit {
  const PaywallBenefit({required this.icon, required this.title});

  final IconData icon;
  final String title;
}

class PaywallBenefitList extends StatelessWidget {
  const PaywallBenefitList({required this.benefits, super.key});

  final List<PaywallBenefit> benefits;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: benefits
          .map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Icon(
                      benefit.icon,
                      color: PaywallColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit.title,
                      style: const TextStyle(
                        color: PaywallColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class PaywallPlanList extends StatelessWidget {
  const PaywallPlanList({
    required this.plans,
    required this.selectedPlanId,
    required this.onPlanSelected,
    super.key,
  });

  final List<PaywallPlan> plans;
  final String selectedPlanId;
  final ValueChanged<PaywallPlan> onPlanSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: plans
          .map(
            (plan) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: PaywallPlanTile(
                plan: plan,
                isSelected: plan.id == selectedPlanId,
                onTap: () => onPlanSelected(plan),
              ),
            ),
          )
          .toList(),
    );
  }
}

class PaywallPlanTile extends StatelessWidget {
  const PaywallPlanTile({
    required this.plan,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final PaywallPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minHeight: 72),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? PaywallColors.selectedPlan
              : AppColors.surfaceTint,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? PaywallColors.primary
                : PaywallColors.cardBorder,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    plan.title,
                    style: const TextStyle(
                      color: PaywallColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan.subtitle,
                    style: const TextStyle(
                      color: PaywallColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (plan.badge != null) ...[
              const SizedBox(width: 8),
              PaywallBadge(text: plan.badge!),
            ],
            const SizedBox(width: 12),
            PaywallSelectionMark(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class PaywallBadge extends StatelessWidget {
  const PaywallBadge({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PaywallColors.discount,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: const TextStyle(
            color: PaywallColors.text,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class PaywallSelectionMark extends StatelessWidget {
  const PaywallSelectionMark({required this.isSelected, super.key});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return const CircleAvatar(
        radius: 12,
        backgroundColor: PaywallColors.primary,
        child: Icon(
          Icons.check_rounded,
          color: PaywallColors.background,
          size: 16,
        ),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: PaywallColors.cardBorder, width: 2),
      ),
    );
  }
}

class PaywallTrialSwitch extends StatelessWidget {
  const PaywallTrialSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Free Trial Enabled',
            style: TextStyle(
              color: PaywallColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Switch(
          value: value,
          activeThumbColor: PaywallColors.primary,
          activeTrackColor: PaywallColors.primaryTrack,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class PaywallContinueButton extends StatelessWidget {
  const PaywallContinueButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: text,
      backgroundColor: PaywallColors.primaryButton,
      onPressed: onPressed,
    );
  }
}

class PaywallFooterLinks extends StatelessWidget {
  const PaywallFooterLinks({
    required this.onRestore,
    required this.onTerms,
    required this.onPrivacy,
    super.key,
  });

  final VoidCallback onRestore;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 12,
      children: [
        PaywallFooterLink(text: 'Restore', onTap: onRestore),
        PaywallFooterLink(text: 'Terms', onTap: onTerms),
        PaywallFooterLink(text: 'Privacy Policy', onTap: onPrivacy),
      ],
    );
  }
}

class PaywallFooterLink extends StatelessWidget {
  const PaywallFooterLink({required this.text, required this.onTap, super.key});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: PaywallColors.text,
          decoration: TextDecoration.underline,
          decorationColor: PaywallColors.text,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

abstract final class PaywallColors {
  static const background = AppColors.background;
  static const selectedPlan = AppColors.surface;
  static const text = AppColors.textPrimary;
  static const mutedText = AppColors.textSecondary;
  static const close = AppColors.textSecondary;
  static const primary = AppColors.primary;
  static const primaryTrack = AppColors.primarySoft;
  static const primaryButton = AppColors.primary;
  static const cardBorder = AppColors.border;
  static const discount = AppColors.secondary;
}
