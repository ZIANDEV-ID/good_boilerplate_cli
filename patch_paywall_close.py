import re

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "r") as f:
    code = f.read()

# 1. Update PaywallPage build to remove Stack/Positioned
old_build_page = """            return Stack(
              children: [
                PaywallContent(
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
                Positioned(
                  top: 22,
                  left: 22,
                  child: DelayedCloseButton(
                    canClose: _canClose,
                    onReady: _showCloseButton,
                    onClose: _close,
                  ),
                ),
              ],
            );"""

new_build_page = """            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
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

code = code.replace(old_build_page, new_build_page)

# 2. Reduce the gap between PaywallBenefitList and PaywallPlanList in PaywallContent
code = code.replace("const SizedBox(height: 160),", "const SizedBox(height: 50),")

# 3. Reduce size of DelayedCloseButton
old_close_button = """  Widget build(BuildContext context) {
    if (canClose) {
      return IconButton(
        icon: const Icon(Icons.close_rounded, size: 38),
        color: PaywallColors.close,
        onPressed: onClose,
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 5),
      onEnd: onReady,
      builder: (context, value, child) {
        return SizedBox.square(
          dimension: 42,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: 2.5,
            color: PaywallColors.primary,
            backgroundColor: PaywallColors.cardBorder,
          ),
        );
      },
    );
  }"""

new_close_button = """  Widget build(BuildContext context) {
    if (canClose) {
      return IconButton(
        icon: const Icon(Icons.close_rounded, size: 24),
        color: PaywallColors.close,
        onPressed: onClose,
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 5),
      onEnd: onReady,
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 2.5,
              color: PaywallColors.primary,
              backgroundColor: PaywallColors.cardBorder,
            ),
          ),
        );
      },
    );
  }"""

code = code.replace(old_close_button, new_close_button)

# Also fix the top padding inside PaywallContent since we have removed the Stack
code = code.replace("padding: const EdgeInsets.fromLTRB(16, 56, 16, 24)", "padding: const EdgeInsets.fromLTRB(16, 16, 16, 24)")

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "w") as f:
    f.write(code)

