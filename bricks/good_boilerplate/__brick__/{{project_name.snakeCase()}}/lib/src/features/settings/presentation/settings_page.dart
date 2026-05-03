import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:{{project_name.snakeCase()}}/src/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/src/core/di/injector.dart';
import 'package:{{project_name.snakeCase()}}/src/core/localization/cubit/language_cubit.dart';
import 'package:{{project_name.snakeCase()}}/src/core/localization/generated/app_localizations.dart';
import 'package:{{project_name.snakeCase()}}/src/core/quota/daily_quota_service.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/app_typography.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/cubit/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const privacyPolicyUrl = 'https://example.com/privacy-policy';
  static const termsOfUseUrl = 'https://example.com/terms-of-use';
  static const contactEmail = 'support@example.com';
  static const objectCaptureFeatureKey = 'object_capture';
  static const objectCaptureDailyLimit = 5;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<ThemeCubit, bool>(
      (cubit) => cubit.isDarkMode,
    );
    final selectedLanguage = context.select<LanguageCubit, AppLanguage>(
      (cubit) => cubit.currentLanguage,
    );
    final l10n = AppLocalizations.of(context);
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
                  SettingsSectionTitle(
                    colors: colors,
                    title: l10n.dailyLimitSection,
                  ),
                  const SizedBox(height: 16),
                  DailyLimitSection(
                    colors: colors,
                    featureKey: objectCaptureFeatureKey,
                    dailyLimit: objectCaptureDailyLimit,
                    onUpgrade: () => context.push(AppRoutes.paywall),
                  ),
                  const SizedBox(height: 24),
                  SettingsCard(
                    colors: colors,
                    children: [
                      SettingsTile(
                        colors: colors,
                        icon: Icons.workspace_premium,
                        iconColor: const Color(0xFFFFD60A),
                        title: l10n.buyPremium,
                        onTap: () => context.push(AppRoutes.paywall),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SettingsSectionTitle(
                    colors: colors,
                    title: l10n.appearanceSection,
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    colors: colors,
                    children: [
                      SettingsSwitchTile(
                        colors: colors,
                        title: l10n.darkMode,
                        value: isDarkMode,
                        onChanged: context.read<ThemeCubit>().setDarkMode,
                      ),
                      SettingsValueTile(
                        colors: colors,
                        title: l10n.language,
                        value: selectedLanguage.nativeName,
                        onTap: () => _showLanguagePicker(context, colors),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SettingsSectionTitle(
                    colors: colors,
                    title: l10n.generalSection,
                  ),
                  const SizedBox(height: 16),
                  SettingsCard(
                    colors: colors,
                    children: [
                      SettingsTile(
                        colors: colors,
                        icon: Icons.star_border_rounded,
                        title: l10n.rateUs,
                        onTap: () {},
                      ),
                      SettingsTile(
                        colors: colors,
                        icon: Icons.privacy_tip_outlined,
                        title: l10n.privacyPolicy,
                        onTap: () => _openUrl(privacyPolicyUrl),
                      ),
                      SettingsTile(
                        colors: colors,
                        icon: Icons.article_outlined,
                        title: l10n.termsOfUse,
                        onTap: () => _openUrl(termsOfUseUrl),
                      ),
                      SettingsTile(
                        colors: colors,
                        icon: Icons.contact_mail_outlined,
                        title: l10n.contactUs,
                        onTap: () => _contactSupport(l10n.supportEmailSubject),
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

  static Future<void> _contactSupport(String subject) async {
    final uri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      queryParameters: {'subject': subject},
    );
    await launchUrl(uri);
  }

  static Future<void> _showLanguagePicker(
    BuildContext context,
    SettingsColors colors,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final l10n = AppLocalizations.of(sheetContext);

        return SafeArea(
          child: BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
                    child: Text(
                      l10n.selectLanguage,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  for (final language in AppLanguage.values)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      leading: Text(
                        language.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        language.nativeName,
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: locale.languageCode == language.code
                          ? const Icon(
                              Icons.check_rounded,
                              color: Color(0xFF3B82F6),
                            )
                          : null,
                      onTap: () {
                        sheetContext.read<LanguageCubit>().setLanguage(
                          language,
                        );
                        Navigator.of(sheetContext).pop();
                      },
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class DailyLimitSection extends StatelessWidget {
  const DailyLimitSection({
    required this.colors,
    required this.featureKey,
    required this.dailyLimit,
    required this.onUpgrade,
    super.key,
  });

  final SettingsColors colors;
  final String featureKey;
  final int dailyLimit;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DailyQuotaState>(
      future: getIt<DailyQuotaService>().getUsage(
        featureKey: featureKey,
        dailyLimit: dailyLimit,
      ),
      builder: (context, snapshot) {
        final state = snapshot.data;
        final used = state?.used ?? 0;
        final max = state?.dailyLimit ?? dailyLimit;
        final progress = max == 0 ? 0.0 : (used / max).clamp(0.0, 1.0);

        return SettingsCard(
          colors: colors,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timelapse_rounded,
                        color: const Color(0xFF3B82F6),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).dailyUsageTitle,
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).dailyUsageCount(used, max),
                        style: TextStyle(
                          color: colors.mutedText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      color: const Color(0xFF3B82F6),
                      backgroundColor: colors.divider,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SettingsActionButton(
                    colors: colors,
                    icon: Icons.workspace_premium_rounded,
                    title: AppLocalizations.of(context).upgradeUnlimitedAccess,
                    onTap: onUpgrade,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({required this.colors, super.key});

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
            AppLocalizations.of(context).settingsTitle,
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
  const SettingsCard({required this.colors, required this.children, super.key});

  final SettingsColors colors;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
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
              Icon(Icons.chevron_right_rounded, color: colors.text, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsValueTile extends StatelessWidget {
  const SettingsValueTile({
    required this.colors,
    required this.title,
    required this.value,
    required this.onTap,
    super.key,
  });

  final SettingsColors colors;
  final String title;
  final String value;
  final VoidCallback onTap;

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
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: colors.mutedText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: colors.text, size: 24),
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

class SettingsActionButton extends StatelessWidget {
  const SettingsActionButton({
    required this.colors,
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  final SettingsColors colors;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD60A),
          foregroundColor: const Color(0xFF111827),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(title),
        onPressed: onTap,
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
