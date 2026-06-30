import 'package:flutter/material.dart';

@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.textOnGlass,
    required this.textOnGlassMuted,
    required this.backgroundBase,
    required this.backgroundSubtle,
    required this.backgroundElevated,
    required this.backgroundFloating,
    required this.backgroundOverlay,
    required this.cardBackground,
    required this.cardBackgroundMuted,
    required this.cardBorder,
    required this.cardShadow,
    required this.inputBackground,
    required this.inputBorder,
    required this.inputFocusedBorder,
    required this.inputErrorBorder,
    required this.inputPlaceholder,
    required this.inputCursor,
    required this.success,
    required this.successContainer,
    required this.onSuccess,
    required this.warning,
    required this.warningContainer,
    required this.onWarning,
    required this.info,
    required this.infoContainer,
    required this.onInfo,
    required this.destructive,
    required this.destructiveContainer,
    required this.onDestructive,
    required this.link,
    required this.focusRing,
    required this.selection,
    required this.pressedOverlay,
    required this.hoverOverlay,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.divider,
    required this.overlay,
    required this.modalBarrier,
    required this.scrimSoft,
    required this.scrimStrong,
    required this.premium,
    required this.premiumGradientStart,
    required this.premiumGradientEnd,
    required this.debug,
    required this.mock,
    required this.updateRequired,
    required this.updateOptional,
  });

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color textOnGlass;
  final Color textOnGlassMuted;
  final Color backgroundBase;
  final Color backgroundSubtle;
  final Color backgroundElevated;
  final Color backgroundFloating;
  final Color backgroundOverlay;
  final Color cardBackground;
  final Color cardBackgroundMuted;
  final Color cardBorder;
  final Color cardShadow;
  final Color inputBackground;
  final Color inputBorder;
  final Color inputFocusedBorder;
  final Color inputErrorBorder;
  final Color inputPlaceholder;
  final Color inputCursor;
  final Color success;
  final Color successContainer;
  final Color onSuccess;
  final Color warning;
  final Color warningContainer;
  final Color onWarning;
  final Color info;
  final Color infoContainer;
  final Color onInfo;
  final Color destructive;
  final Color destructiveContainer;
  final Color onDestructive;
  final Color link;
  final Color focusRing;
  final Color selection;
  final Color pressedOverlay;
  final Color hoverOverlay;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color divider;
  final Color overlay;
  final Color modalBarrier;
  final Color scrimSoft;
  final Color scrimStrong;
  final Color premium;
  final Color premiumGradientStart;
  final Color premiumGradientEnd;
  final Color debug;
  final Color mock;
  final Color updateRequired;
  final Color updateOptional;

  static const light = AppColorTokens(
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF4B5563),
    textTertiary: Color(0xFF8E8E93),
    textDisabled: Color(0xFF9CA3AF),
    textOnGlass: Color(0xFF111827),
    textOnGlassMuted: Color(0xFF4B5563),
    backgroundBase: Color(0xFFF7F8FB),
    backgroundSubtle: Color(0xFFF3F4F6),
    backgroundElevated: Color(0xFFFFFFFF),
    backgroundFloating: Color(0xEFFFFFFF),
    backgroundOverlay: Color(0x66FFFFFF),
    cardBackground: Color(0x94FFFFFF),
    cardBackgroundMuted: Color(0x7AFFFFFF),
    cardBorder: Color(0xB8FFFFFF),
    cardShadow: Color(0x1F0F172A),
    inputBackground: Color(0xCCFFFFFF),
    inputBorder: Color(0xFFD1D5DB),
    inputFocusedBorder: Color(0xFF0A84FF),
    inputErrorBorder: Color(0xFFFF453A),
    inputPlaceholder: Color(0xFF8E8E93),
    inputCursor: Color(0xFF0A84FF),
    success: Color(0xFF30D158),
    successContainer: Color(0xFFDDFBE8),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFFFFD60A),
    warningContainer: Color(0xFFFFEBC2),
    onWarning: Color(0xFF111827),
    info: Color(0xFF00B8D9),
    infoContainer: Color(0xFFD6F7FF),
    onInfo: Color(0xFF003D4F),
    destructive: Color(0xFFFF453A),
    destructiveContainer: Color(0xFFFFE2DE),
    onDestructive: Color(0xFFFFFFFF),
    link: Color(0xFF0A84FF),
    focusRing: Color(0x660A84FF),
    selection: Color(0x330A84FF),
    pressedOverlay: Color(0x1F0F172A),
    hoverOverlay: Color(0x140F172A),
    disabledBackground: Color(0xFFE5E7EB),
    disabledForeground: Color(0xFF9CA3AF),
    divider: Color(0xFFD1D5DB),
    overlay: Color(0x660F172A),
    modalBarrier: Color(0x730F172A),
    scrimSoft: Color(0x330F172A),
    scrimStrong: Color(0x990F172A),
    premium: Color(0xFFFF9F0A),
    premiumGradientStart: Color(0xFF0A84FF),
    premiumGradientEnd: Color(0xFF7C5CFF),
    debug: Color(0xFF7C5CFF),
    mock: Color(0xFF00B8D9),
    updateRequired: Color(0xFFFF453A),
    updateOptional: Color(0xFF0A84FF),
  );

  static const dark = AppColorTokens(
    textPrimary: Color(0xFFF5F7FA),
    textSecondary: Color(0xFFC9CED6),
    textTertiary: Color(0xFF8E96A3),
    textDisabled: Color(0xFF687385),
    textOnGlass: Color(0xFFF5F7FA),
    textOnGlassMuted: Color(0xFFC9CED6),
    backgroundBase: Color(0xFF070A0F),
    backgroundSubtle: Color(0xFF0D1117),
    backgroundElevated: Color(0xFF151A23),
    backgroundFloating: Color(0xE6151A23),
    backgroundOverlay: Color(0x66070A0F),
    cardBackground: Color(0x8A141820),
    cardBackgroundMuted: Color(0x66141820),
    cardBorder: Color(0x24FFFFFF),
    cardShadow: Color(0x61000000),
    inputBackground: Color(0x99151A23),
    inputBorder: Color(0xFF303744),
    inputFocusedBorder: Color(0xFF2997FF),
    inputErrorBorder: Color(0xFFFF6961),
    inputPlaceholder: Color(0xFF8E96A3),
    inputCursor: Color(0xFF2997FF),
    success: Color(0xFF32D74B),
    successContainer: Color(0xFF123B25),
    onSuccess: Color(0xFF052E16),
    warning: Color(0xFFFFD60A),
    warningContainer: Color(0xFF4A3209),
    onWarning: Color(0xFF422006),
    info: Color(0xFF64D2FF),
    infoContainer: Color(0xFF003D4F),
    onInfo: Color(0xFF06283A),
    destructive: Color(0xFFFF6961),
    destructiveContainer: Color(0xFF5F1612),
    onDestructive: Color(0xFF3F0806),
    link: Color(0xFF2997FF),
    focusRing: Color(0x662997FF),
    selection: Color(0x332997FF),
    pressedOverlay: Color(0x24FFFFFF),
    hoverOverlay: Color(0x1AFFFFFF),
    disabledBackground: Color(0xFF303744),
    disabledForeground: Color(0xFF687385),
    divider: Color(0xFF303744),
    overlay: Color(0x99000000),
    modalBarrier: Color(0xA6000000),
    scrimSoft: Color(0x66000000),
    scrimStrong: Color(0xCC000000),
    premium: Color(0xFFFFB340),
    premiumGradientStart: Color(0xFF2997FF),
    premiumGradientEnd: Color(0xFF9B8CFF),
    debug: Color(0xFF9B8CFF),
    mock: Color(0xFF64D2FF),
    updateRequired: Color(0xFFFF6961),
    updateOptional: Color(0xFF2997FF),
  );

  @override
  AppColorTokens copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? textOnGlass,
    Color? textOnGlassMuted,
    Color? backgroundBase,
    Color? backgroundSubtle,
    Color? backgroundElevated,
    Color? backgroundFloating,
    Color? backgroundOverlay,
    Color? cardBackground,
    Color? cardBackgroundMuted,
    Color? cardBorder,
    Color? cardShadow,
    Color? inputBackground,
    Color? inputBorder,
    Color? inputFocusedBorder,
    Color? inputErrorBorder,
    Color? inputPlaceholder,
    Color? inputCursor,
    Color? success,
    Color? successContainer,
    Color? onSuccess,
    Color? warning,
    Color? warningContainer,
    Color? onWarning,
    Color? info,
    Color? infoContainer,
    Color? onInfo,
    Color? destructive,
    Color? destructiveContainer,
    Color? onDestructive,
    Color? link,
    Color? focusRing,
    Color? selection,
    Color? pressedOverlay,
    Color? hoverOverlay,
    Color? disabledBackground,
    Color? disabledForeground,
    Color? divider,
    Color? overlay,
    Color? modalBarrier,
    Color? scrimSoft,
    Color? scrimStrong,
    Color? premium,
    Color? premiumGradientStart,
    Color? premiumGradientEnd,
    Color? debug,
    Color? mock,
    Color? updateRequired,
    Color? updateOptional,
  }) {
    return AppColorTokens(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      textOnGlass: textOnGlass ?? this.textOnGlass,
      textOnGlassMuted: textOnGlassMuted ?? this.textOnGlassMuted,
      backgroundBase: backgroundBase ?? this.backgroundBase,
      backgroundSubtle: backgroundSubtle ?? this.backgroundSubtle,
      backgroundElevated: backgroundElevated ?? this.backgroundElevated,
      backgroundFloating: backgroundFloating ?? this.backgroundFloating,
      backgroundOverlay: backgroundOverlay ?? this.backgroundOverlay,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBackgroundMuted: cardBackgroundMuted ?? this.cardBackgroundMuted,
      cardBorder: cardBorder ?? this.cardBorder,
      cardShadow: cardShadow ?? this.cardShadow,
      inputBackground: inputBackground ?? this.inputBackground,
      inputBorder: inputBorder ?? this.inputBorder,
      inputFocusedBorder: inputFocusedBorder ?? this.inputFocusedBorder,
      inputErrorBorder: inputErrorBorder ?? this.inputErrorBorder,
      inputPlaceholder: inputPlaceholder ?? this.inputPlaceholder,
      inputCursor: inputCursor ?? this.inputCursor,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfo: onInfo ?? this.onInfo,
      destructive: destructive ?? this.destructive,
      destructiveContainer:
          destructiveContainer ?? this.destructiveContainer,
      onDestructive: onDestructive ?? this.onDestructive,
      link: link ?? this.link,
      focusRing: focusRing ?? this.focusRing,
      selection: selection ?? this.selection,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      disabledForeground: disabledForeground ?? this.disabledForeground,
      divider: divider ?? this.divider,
      overlay: overlay ?? this.overlay,
      modalBarrier: modalBarrier ?? this.modalBarrier,
      scrimSoft: scrimSoft ?? this.scrimSoft,
      scrimStrong: scrimStrong ?? this.scrimStrong,
      premium: premium ?? this.premium,
      premiumGradientStart:
          premiumGradientStart ?? this.premiumGradientStart,
      premiumGradientEnd: premiumGradientEnd ?? this.premiumGradientEnd,
      debug: debug ?? this.debug,
      mock: mock ?? this.mock,
      updateRequired: updateRequired ?? this.updateRequired,
      updateOptional: updateOptional ?? this.updateOptional,
    );
  }

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColorTokens(
      textPrimary: lerpColor(textPrimary, other.textPrimary),
      textSecondary: lerpColor(textSecondary, other.textSecondary),
      textTertiary: lerpColor(textTertiary, other.textTertiary),
      textDisabled: lerpColor(textDisabled, other.textDisabled),
      textOnGlass: lerpColor(textOnGlass, other.textOnGlass),
      textOnGlassMuted: lerpColor(textOnGlassMuted, other.textOnGlassMuted),
      backgroundBase: lerpColor(backgroundBase, other.backgroundBase),
      backgroundSubtle: lerpColor(backgroundSubtle, other.backgroundSubtle),
      backgroundElevated: lerpColor(
        backgroundElevated,
        other.backgroundElevated,
      ),
      backgroundFloating: lerpColor(
        backgroundFloating,
        other.backgroundFloating,
      ),
      backgroundOverlay: lerpColor(backgroundOverlay, other.backgroundOverlay),
      cardBackground: lerpColor(cardBackground, other.cardBackground),
      cardBackgroundMuted: lerpColor(
        cardBackgroundMuted,
        other.cardBackgroundMuted,
      ),
      cardBorder: lerpColor(cardBorder, other.cardBorder),
      cardShadow: lerpColor(cardShadow, other.cardShadow),
      inputBackground: lerpColor(inputBackground, other.inputBackground),
      inputBorder: lerpColor(inputBorder, other.inputBorder),
      inputFocusedBorder: lerpColor(
        inputFocusedBorder,
        other.inputFocusedBorder,
      ),
      inputErrorBorder: lerpColor(inputErrorBorder, other.inputErrorBorder),
      inputPlaceholder: lerpColor(inputPlaceholder, other.inputPlaceholder),
      inputCursor: lerpColor(inputCursor, other.inputCursor),
      success: lerpColor(success, other.success),
      successContainer: lerpColor(successContainer, other.successContainer),
      onSuccess: lerpColor(onSuccess, other.onSuccess),
      warning: lerpColor(warning, other.warning),
      warningContainer: lerpColor(warningContainer, other.warningContainer),
      onWarning: lerpColor(onWarning, other.onWarning),
      info: lerpColor(info, other.info),
      infoContainer: lerpColor(infoContainer, other.infoContainer),
      onInfo: lerpColor(onInfo, other.onInfo),
      destructive: lerpColor(destructive, other.destructive),
      destructiveContainer: lerpColor(
        destructiveContainer,
        other.destructiveContainer,
      ),
      onDestructive: lerpColor(onDestructive, other.onDestructive),
      link: lerpColor(link, other.link),
      focusRing: lerpColor(focusRing, other.focusRing),
      selection: lerpColor(selection, other.selection),
      pressedOverlay: lerpColor(pressedOverlay, other.pressedOverlay),
      hoverOverlay: lerpColor(hoverOverlay, other.hoverOverlay),
      disabledBackground: lerpColor(
        disabledBackground,
        other.disabledBackground,
      ),
      disabledForeground: lerpColor(
        disabledForeground,
        other.disabledForeground,
      ),
      divider: lerpColor(divider, other.divider),
      overlay: lerpColor(overlay, other.overlay),
      modalBarrier: lerpColor(modalBarrier, other.modalBarrier),
      scrimSoft: lerpColor(scrimSoft, other.scrimSoft),
      scrimStrong: lerpColor(scrimStrong, other.scrimStrong),
      premium: lerpColor(premium, other.premium),
      premiumGradientStart: lerpColor(
        premiumGradientStart,
        other.premiumGradientStart,
      ),
      premiumGradientEnd: lerpColor(
        premiumGradientEnd,
        other.premiumGradientEnd,
      ),
      debug: lerpColor(debug, other.debug),
      mock: lerpColor(mock, other.mock),
      updateRequired: lerpColor(updateRequired, other.updateRequired),
      updateOptional: lerpColor(updateOptional, other.updateOptional),
    );
  }
}
