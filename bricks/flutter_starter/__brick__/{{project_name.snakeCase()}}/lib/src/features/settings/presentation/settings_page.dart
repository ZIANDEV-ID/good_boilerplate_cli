import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:{{project_name.snakeCase()}}/src/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/cubit/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const privacyPolicyUrl = 'https://example.com/privacy-policy';
  static const termsOfUseUrl = 'https://example.com/terms-of-use';
  static const contactEmail = 'support@example.com';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<ThemeCubit, bool>(
      (cubit) => cubit.isDarkMode,
    );
    final colors = SettingsColors.fromBrightness(
      isDarkMode ? Brightness.dark : Brightness.light,
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SettingsHeader(colors: colors),
            Divider(height: 1, color: colors.divider),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                children: [
                  SettingsCard(
                    colors: colors,
                    children: [
                      SettingsTile(
                        colors: colors,
                        icon: Icons.workspace_premium,
                        iconColor: const Color(0xFFFFD60A),
                        title: 'Buy Premium',
                        onTap: () => context.push(AppRoutes.paywall),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SettingsSectionTitle(
                    colors: colors,
                    title: 'Appearance',
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    colors: colors,
                    children: [
                      SettingsSwitchTile(
                        colors: colors,
                        title: 'Dark Mode',
                        value: isDarkMode,
                        onChanged: context.read<ThemeCubit>().setDarkMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SettingsSectionTitle(
                    colors: colors,
                    title: 'General',
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    colors: colors,
                    children: [
                      SettingsTile(
                        colors: colors,
                        icon: Icons.star_border_rounded,
                        title: 'Rate us',
                        onTap: () {},
                      ),
                      SettingsTile(
                        colors: colors,
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        onTap: () => _openUrl(privacyPolicyUrl),
                      ),
                      SettingsTile(
                        colors: colors,
                        icon: Icons.article_outlined,
                        title: 'Terms of Use',
                        onTap: () => _openUrl(termsOfUseUrl),
                      ),
                      SettingsTile(
                        colors: colors,
                        icon: Icons.contact_mail_outlined,
                        title: 'Contact Us',
                        onTap: _contactSupport,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _contactSupport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      queryParameters: {'subject': 'Support Request'},
    );
    await launchUrl(uri);
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    required this.colors,
    super.key,
  });

  final SettingsColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, size: 24),
              color: colors.text,
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                  return;
                }

                context.go('/home');
              },
            ),
          ),
          Text(
            'Settings',
            style: TextStyle(
              color: colors.text,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsSectionTitle extends StatelessWidget {
  const SettingsSectionTitle({
    required this.colors,
    required this.title,
    super.key,
  });

  final SettingsColors colors;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: colors.mutedText,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.colors,
    required this.children,
    super.key,
  });

  final SettingsColors colors;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.colors,
    required this.icon,
    required this.title,
    this.iconColor,
    this.onTap,
    super.key,
  });

  final SettingsColors colors;
  final IconData icon;
  final Color? iconColor;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? colors.icon, size: 24),
              const SizedBox(width: 16),
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
              Icon(
                Icons.chevron_right_rounded,
                color: colors.text,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
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
}

class SettingsColors {
  const SettingsColors({
    required this.background,
    required this.card,
    required this.text,
    required this.mutedText,
    required this.icon,
    required this.divider,
  });

  factory SettingsColors.fromBrightness(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const SettingsColors(
        background: Color(0xFF1C1C1E),
        card: Color(0xFF2C2C2E),
        text: Colors.white,
        mutedText: Color(0xFF7D7D83),
        icon: Colors.white,
        divider: Color(0xFF38383A),
      );
    }

    return const SettingsColors(
      background: Color(0xFFF7F8FA),
      card: Colors.white,
      text: Color(0xFF111827),
      mutedText: Color(0xFF7C8493),
      icon: Color(0xFF111827),
      divider: Color(0xFFE5E7EB),
    );
  }

  final Color background;
  final Color card;
  final Color text;
  final Color mutedText;
  final Color icon;
  final Color divider;
}
