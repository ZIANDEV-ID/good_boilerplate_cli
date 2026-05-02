import re

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "r") as f:
    code = f.read()

# Replace the entire LayoutBuilder with a simple Padding > Column structure
old_content = """    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
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
                      PaywallBenefit(
                        icon: Icons.block_rounded,
                        title: 'No Ads',
                      ),
                      PaywallBenefit(
                        icon: Icons.lock_outline_rounded,
                        title: 'No Annoying Paywalls',
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  if (isLoading) const LinearProgressIndicator(minHeight: 2),
                  PaywallPlanList(
                    plans: plans,
                    selectedPlanId: selectedPlanId,
                    onPlanSelected: onPlanSelected,
                  ),
                  const SizedBox(height: 24),
                  PaywallTrialSwitch(
                    value: freeTrialEnabled,
                    onChanged: onFreeTrialChanged,
                  ),
                  const SizedBox(height: 24),
                  PaywallContinueButton(
                    text: 'Continue',
                    onPressed: onContinue,
                  ),
                  const SizedBox(height: 24),
                  PaywallFooterLinks(
                    onRestore: onRestore,
                    onTerms: onTerms,
                    onPrivacy: onPrivacy,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );"""

new_content = """    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
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
              PaywallBenefit(
                icon: Icons.block_rounded,
                title: 'No Ads',
              ),
              PaywallBenefit(
                icon: Icons.lock_outline_rounded,
                title: 'No Annoying Paywalls',
              ),
            ],
          ),
          const SizedBox(height: 8),
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
            text: 'Continue',
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
    );"""

code = code.replace(old_content, new_content)

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "w") as f:
    f.write(code)

