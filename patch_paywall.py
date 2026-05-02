import re

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "r") as f:
    code = f.read()

# PaywallContent Layout
code = code.replace("padding: const EdgeInsets.fromLTRB(24, 90, 24, 28)", "padding: const EdgeInsets.fromLTRB(16, 56, 16, 24)")
code = code.replace("SizedBox(height: 38)", "SizedBox(height: 24)")

# PaywallHero
code = code.replace("size: 130", "size: 80")
code = code.replace("SizedBox(height: 18)", "SizedBox(height: 12)")
code = code.replace("fontSize: 48", "fontSize: 28")
code = code.replace("fontWeight: FontWeight.w800", "fontWeight: FontWeight.w700")

# PaywallBenefitList
code = code.replace("padding: const EdgeInsets.only(bottom: 24)", "padding: const EdgeInsets.only(bottom: 16)")
code = code.replace("width: 48", "width: 32")
code = code.replace("size: 34", "size: 24")
code = code.replace("SizedBox(width: 20)", "SizedBox(width: 12)")
code = code.replace("fontSize: 28", "fontSize: 16")

# PaywallPlanList
code = code.replace("SizedBox(height: 24)", "SizedBox(height: 16)")
code = code.replace("padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18)", "padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)")
code = code.replace("border: Border.all(color: PaywallColors.primary, width: 4)", "border: Border.all(color: PaywallColors.primary, width: 2)")

# PaywallPlanTile Details
code = code.replace("fontSize: 30", "fontSize: 18") # Plan title
code = code.replace("fontWeight: FontWeight.w600", "fontWeight: FontWeight.w600")
code = code.replace("fontSize: 23", "fontSize: 14") # Plan subtitle
code = code.replace("SizedBox(width: 12)", "SizedBox(width: 8)")
code = code.replace("SizedBox(width: 18)", "SizedBox(width: 12)")

# PaywallBadge
code = code.replace("borderRadius: BorderRadius.circular(7)", "borderRadius: BorderRadius.circular(6)")
code = code.replace("padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10)", "padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)")
code = code.replace("fontSize: 21", "fontSize: 12")

# PaywallSelectionMark
code = code.replace("radius: 17", "radius: 12")
code = code.replace("size: 28", "size: 16")
code = code.replace("width: 34", "width: 24")
code = code.replace("height: 34", "height: 24")
code = code.replace("border: Border.all(color: PaywallColors.cardBorder, width: 3)", "border: Border.all(color: PaywallColors.cardBorder, width: 2)")

# PaywallTrialSwitch
code = code.replace("fontSize: 25", "fontSize: 16")

# PaywallContinueButton
code = code.replace("height: 78", "height: 56")
code = code.replace("borderRadius: BorderRadius.circular(18)", "borderRadius: BorderRadius.circular(12)")
code = code.replace("fontSize: 31", "fontSize: 18")

# PaywallFooterLinks
code = code.replace("spacing: 34", "spacing: 24")
code = code.replace("fontSize: 21", "fontSize: 14")


with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "w") as f:
    f.write(code)

