with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "r") as f:
    lines = f.readlines()

start_idx = -1
end_idx = -1

for i, line in enumerate(lines):
    if "class PaywallContent extends StatelessWidget" in line:
        for j in range(i, len(lines)):
            if "  @override" in lines[j] and "  Widget build(BuildContext context) {" in lines[j+1]:
                start_idx = j
                break
        if start_idx != -1:
            break

if start_idx != -1:
    # Find the end of the build method by matching braces or just by finding the next class
    for i in range(start_idx + 2, len(lines)):
        if "class PaywallHero extends StatelessWidget" in lines[i]:
            end_idx = i - 1
            break

if start_idx != -1 and end_idx != -1:
    new_build = """  @override
  Widget build(BuildContext context) {
    return Padding(
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
"""
    lines[start_idx:end_idx] = [new_build]

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "w") as f:
    f.writelines(lines)

