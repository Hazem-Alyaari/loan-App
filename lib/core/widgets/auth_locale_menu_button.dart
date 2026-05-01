import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loan/core/locale/app_locale.dart';
import 'package:loan/core/locale/l10n_context.dart';
import 'package:loan/core/theme/app_theme.dart';

/// Language picker for auth screens (login / register) where profile is unavailable.
class AuthLocaleMenuButton extends ConsumerWidget {
  const AuthLocaleMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final code = ref.watch(appLocaleProvider).languageCode;

    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        tooltip: l10n.labelLanguage,
        offset: const Offset(0, 44),
        color: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (v) {
          ref.read(appLocaleProvider.notifier).setLocale(Locale(v));
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'ar',
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: code == 'ar'
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary, size: 20)
                      : const SizedBox.shrink(),
                ),
                Text(l10n.languageArabic),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'en',
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: code == 'en'
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary, size: 20)
                      : const SizedBox.shrink(),
                ),
                Text(l10n.languageEnglish),
              ],
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF333355)),
          ),
          child: const Icon(
            Icons.language_rounded,
            color: AppColors.primary,
            size: 26,
          ),
        ),
      ),
    );
  }
}
