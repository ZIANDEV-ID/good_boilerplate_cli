import re

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/onboarding/presentation/onboarding_page.dart", "r") as f:
    code = f.read()

# Padding OnboardingView
code = code.replace("padding: const EdgeInsets.fromLTRB(28, 34, 28, 24)", "padding: const EdgeInsets.fromLTRB(16, 24, 16, 16)")

# OnboardingStepper
code = code.replace("height: 40", "height: 24")
code = code.replace("margin: const EdgeInsets.symmetric(horizontal: 12)", "margin: const EdgeInsets.symmetric(horizontal: 8)")
code = code.replace("width: 22", "width: 12")
code = code.replace("height: 22", "height: 12")

# OnboardingSlideContent / Text Sizes
code = code.replace("fontSize: isCompact ? 28 : 36", "fontSize: isCompact ? 24 : 28")
code = code.replace("fontSize: isCompact ? 16 : 20", "fontSize: isCompact ? 14 : 16")

# OnboardingPrimaryButton
code = code.replace("height: 66", "height: 56")
code = code.replace("borderRadius: BorderRadius.circular(16)", "borderRadius: BorderRadius.circular(12)")
code = code.replace("fontSize: 24", "fontSize: 16")
code = code.replace("fontWeight: FontWeight.w700", "fontWeight: FontWeight.w600")

# TrustedInfo
code = code.replace("fontSize: 18", "fontSize: 14")


with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/onboarding/presentation/onboarding_page.dart", "w") as f:
    f.write(code)

