import 'package:flutter/material.dart';
import 'package:loan/core/locale/l10n_context.dart';
import 'package:loan/core/theme/app_theme.dart';

/// General privacy policy placeholder — have it reviewed legally before commercial release.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyScreenTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
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
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.privacyUpdated(DateTime.now().year),
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                _section(
                  title: l10n.privacyS1t,
                  body: l10n.privacyS1b,
                ),
                _section(
                  title: l10n.privacyS2t,
                  body: l10n.privacyS2b,
                ),
                _section(
                  title: l10n.privacyS3t,
                  body: l10n.privacyS3b,
                ),
                _section(
                  title: l10n.privacyS4t,
                  body: l10n.privacyS4b,
                ),
                _section(
                  title: l10n.privacyS5t,
                  body: l10n.privacyS5b,
                ),
                _section(
                  title: l10n.privacyS6t,
                  body: l10n.privacyS6b,
                ),
                _section(
                  title: l10n.privacyS7t,
                  body: l10n.privacyS7b,
                ),
                _section(
                  title: l10n.privacyS8t,
                  body: l10n.privacyS8b,
                ),
                _section(
                  title: l10n.privacyS9t,
                  body: l10n.privacyS9b,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section({required String title, required String body}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

extension OpenPrivacyPolicy on BuildContext {
  void openPrivacyPolicy() {
    Navigator.of(this).push<void>(
      MaterialPageRoute(
        builder: (_) => const PrivacyPolicyScreen(),
      ),
    );
  }
}
