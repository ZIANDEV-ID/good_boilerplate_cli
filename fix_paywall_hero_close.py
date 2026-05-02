import re

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "r") as f:
    code = f.read()

# Make the page body padding and layout more cohesive
# Remove the separate header Close Button from _PaywallPageState
old_scaffold_column = """            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 0.0),
                    child: DelayedCloseButton(
                      canClose: _canClose,
                      onReady: _showCloseButton,
                      onClose: _close,
                    ),
                  ),
                ),
                Expanded(
                  child: PaywallContent(
                    plans: plans,
                    selectedPlanId: selectedPlanId,
                    freeTrialEnabled: _freeTrialEnabled,
                    isLoading: snapshot.connectionState == ConnectionState.waiting,
                    onPlanSelected: _selectPlan,
                    onFreeTrialChanged: (value) {
                      _setFreeTrialEnabled(value, plans);
                    },
                    onContinue: () => _continue(selectedPlan),
                    onRestore: _restore,
                    onTerms: () => _openUrl(PaywallPage.termsOfUseUrl),
                    onPrivacy: () => _openUrl(PaywallPage.privacyPolicyUrl),
                  ),
                ),
              ],
            );"""

new_scaffold_column = """            return PaywallContent(
              plans: plans,
              selectedPlanId: selectedPlanId,
              freeTrialEnabled: _freeTrialEnabled,
              isLoading: snapshot.connectionState == ConnectionState.waiting,
              canClose: _canClose,
              onClose: _close,
              onReady: _showCloseButton,
              onPlanSelected: _selectPlan,
              onFreeTrialChanged: (value) {
                _setFreeTrialEnabled(value, plans);
              },
              onContinue: () => _continue(selectedPlan),
              onRestore: _restore,
              onTerms: () => _openUrl(PaywallPage.termsOfUseUrl),
              onPrivacy: () => _openUrl(PaywallPage.privacyPolicyUrl),
            );"""

code = code.replace(old_scaffold_column, new_scaffold_column)

# Update PaywallContent constructor to take Close Button params
old_content_constructor = """class PaywallContent extends StatelessWidget {
  const PaywallContent({
    required this.plans,
    required this.selectedPlanId,
    required this.freeTrialEnabled,
    required this.isLoading,
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
  final ValueChanged<PaywallPlan> onPlanSelected;
  final ValueChanged<bool> onFreeTrialChanged;
  final VoidCallback onContinue;
  final VoidCallback onRestore;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;"""

new_content_constructor = """class PaywallContent extends StatelessWidget {
  const PaywallContent({
    required this.plans,
    required this.selectedPlanId,
    required this.freeTrialEnabled,
    required this.isLoading,
    required this.canClose,
    required this.onClose,
    required this.onReady,
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
  final bool canClose;
  final VoidCallback onClose;
  final VoidCallback onReady;
  final ValueChanged<PaywallPlan> onPlanSelected;
  final ValueChanged<bool> onFreeTrialChanged;
  final VoidCallback onContinue;
  final VoidCallback onRestore;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;"""

code = code.replace(old_content_constructor, new_content_constructor)

# Move the CloseButton directly into PaywallContent, above the Hero, with 20px gap
old_content_build = """  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          const PaywallHero(),
          const SizedBox(height: 16),"""

new_content_build = """  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: DelayedCloseButton(
              canClose: canClose,
              onReady: onReady,
              onClose: onClose,
            ),
          ),
          const SizedBox(height: 20),
          const PaywallHero(),
          const SizedBox(height: 16),"""

code = code.replace(old_content_build, new_content_build)

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "w") as f:
    f.write(code)

