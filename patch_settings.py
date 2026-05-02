import re

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/settings/presentation/settings_page.dart", "r") as f:
    code = f.read()

# Fix the broken patch on SettingsSwitchTile
fixed_code = code.replace("""return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Switch(
              value: value,
              activeThumbColor: const Color(0xFF3B82F6),
              activeTrackColor: const Color(0xFF3B82F6).withValues(alpha: 0.6),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}""", """class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    required this.colors,
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final SettingsColors colors;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Switch(
              value: value,
              activeThumbColor: const Color(0xFF3B82F6),
              activeTrackColor: const Color(0xFF3B82F6).withValues(alpha: 0.6),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}""")

# Additional fix: some fontSize was converted to 14, standardizing to 16
fixed_code = fixed_code.replace("fontSize: 14", "fontSize: 16")

with open("bricks/flutter_starter/__brick__/{{project_name.snakeCase()}}/lib/src/features/settings/presentation/settings_page.dart", "w") as f:
    f.write(fixed_code)
