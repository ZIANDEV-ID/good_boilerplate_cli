import re

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "r") as f:
    code = f.read()

# PaywallPlanTile Details (lanjutan)
code = code.replace("constraints: const BoxConstraints(minHeight: 108)", "constraints: const BoxConstraints(minHeight: 72)")
code = code.replace("padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)", "padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)")
code = code.replace("fontSize: 16,\n                      fontWeight: FontWeight.w700", "fontSize: 16,\n                      fontWeight: FontWeight.w600")

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "w") as f:
    f.write(code)

