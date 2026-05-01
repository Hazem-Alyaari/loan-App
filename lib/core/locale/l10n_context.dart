import 'package:flutter/widgets.dart';
import 'package:loan/l10n/app_localizations.dart';

extension L10nBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
