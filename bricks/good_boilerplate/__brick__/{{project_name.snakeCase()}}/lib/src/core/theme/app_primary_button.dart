import 'package:flutter/material.dart';
{{#theme_style_neubrutalism}}
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
{{/theme_style_neubrutalism}}

import 'app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.textPrimary,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
{{#theme_style_soft_pastel}}
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: icon == null
          ? ElevatedButton(onPressed: onPressed, child: Text(label))
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
            ),
    );
{{/theme_style_soft_pastel}}
{{#theme_style_neubrutalism}}
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonWidth = constraints.maxWidth > 4
              ? constraints.maxWidth - 4
              : constraints.maxWidth;

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              NeuTextButton(
                enableAnimation: true,
                text: Text(
                  icon == null ? label : '      $label',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                buttonColor: backgroundColor,
                buttonHeight: 52,
                buttonWidth: buttonWidth,
                borderWidth: 2,
                borderRadius: BorderRadius.zero,
                onPressed: onPressed,
              ),
              if (icon != null)
                Positioned(
                  left: 18,
                  child: Icon(icon, color: foregroundColor, size: 20),
                ),
            ],
          );
        },
      ),
    );
{{/theme_style_neubrutalism}}
  }
}
