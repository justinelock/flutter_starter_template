import 'package:flutter/widgets.dart';
import 'package:flutter_starter_template/l10n/generated/app_localizations.dart';

extension L10nExtensions on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
