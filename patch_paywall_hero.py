import re

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "r") as f:
    code = f.read()

# PaywallHero Update
code = code.replace("size: 88", "size: 64") # Scale down the icon slightly
code = code.replace("SizedBox(height: 28)", "SizedBox(height: 10)") # 10px gap between icon and text
code = code.replace("fontSize: 34", "fontSize: 24") # Make the text smaller

# Adjust PaywallPage top structure to move it up and align Close button above the Hero
# Previously:
# Align(
#   alignment: Alignment.centerLeft,
#   child: Padding(
#     padding: const EdgeInsets.only(left: 16.0, top: 16.0),
#     child: DelayedCloseButton(
#       ...
#     ),
#   ),
# ),

code = code.replace("padding: const EdgeInsets.only(left: 16.0, top: 16.0)", "padding: const EdgeInsets.only(left: 0.0, top: 0.0)")

# Also, ensure PaywallContent has smaller top padding so everything moves up
code = code.replace("padding: const EdgeInsets.fromLTRB(16, 16, 16, 24)", "padding: const EdgeInsets.fromLTRB(16, 8, 16, 24)")

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/paywall/presentation/paywall_page.dart", "w") as f:
    f.write(code)

