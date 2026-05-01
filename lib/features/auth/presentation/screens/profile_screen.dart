import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/core/locale/app_locale.dart';
import 'package:loan/core/locale/l10n_context.dart';
import 'package:loan/core/theme/app_theme.dart';
import 'package:loan/core/widgets/glass_card.dart';
import 'package:loan/l10n/app_localizations.dart';
import 'package:loan/features/auth/application/providers/auth_providers.dart';
import 'package:loan/features/auth/presentation/screens/privacy_policy_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profileAsync = ref.watch(currentUserProfileProvider);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AsyncLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
          ),
        ),
        child: profileAsync.when(
          data: (profile) {
            if (profile == null) {
              return Center(
                child: Text(
                  l10n.profileMissing,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ProfileRow(
                        label: l10n.labelPhone,
                        value: profile.phoneNumber ?? '-',
                      ),
                      const SizedBox(height: 10),
                      _ProfileRow(
                        label: l10n.labelAuthMethod,
                        value: _providerLabel(l10n, profile.authProvider.name),
                      ),
                      if (profile.mustChangePassword) ...[
                        const SizedBox(height: 14),
                        Text(
                          l10n.defaultPasswordBanner,
                          style: const TextStyle(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    l10n.privacyRelated,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    l10n.privacyRelatedSub,
                    style: const TextStyle(color: AppColors.textHint, fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.textHint,
                  ),
                  onTap: () => context.openPrivacyPolicy(),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.language_rounded, color: AppColors.primary),
                  title: Text(l10n.labelLanguage, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                  trailing: DropdownButton<String>(
                    value: ref.watch(appLocaleProvider).languageCode,
                    dropdownColor: AppColors.surfaceLight,
                    underline: const SizedBox.shrink(),
                    items: [
                      DropdownMenuItem(value: 'ar', child: Text(l10n.languageArabic)),
                      DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(appLocaleProvider.notifier).setLocale(Locale(v));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.changePassword,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: true,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: l10n.hintCurrentPassword,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.textHint,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.valCurrentPasswordRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: l10n.hintNewPassword,
                            prefixIcon: Icon(
                              Icons.lock_reset_outlined,
                              color: AppColors.textHint,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.valNewPasswordRequired;
                            }
                            if (value.length < 8) {
                              return l10n.valNewPasswordMin8;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: l10n.hintConfirmNewPassword,
                            prefixIcon: Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.textHint,
                            ),
                          ),
                          validator: (value) {
                            if (value != _newPasswordController.text) {
                              return l10n.valPasswordMismatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: isLoading ? null : _handleChangePassword,
                            child: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.updatePasswordButton),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, _) => Center(
            child: Text(
              l10n.errorPrefix(error.toString()),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10nSnack = context.l10n;
    try {
      await ref.read(authControllerProvider.notifier).changePassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      messenger.showSnackBar(
        SnackBar(content: Text(l10nSnack.passwordChangedSnack)),
      );
      ref.invalidate(currentUserProfileProvider);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

String _providerLabel(AppLocalizations l10n, String provider) {
  return switch (provider) {
    'email' => l10n.authProviderEmail,
    'google' => l10n.authProviderGoogle,
    _ => provider,
  };
}
