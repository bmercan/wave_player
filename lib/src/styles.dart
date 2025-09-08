import 'package:flutter/material.dart';

/// Wave Player Theme Configuration
class WavePlayerTheme {
  const WavePlayerTheme({
    this.primaryColor = const Color(0xFF007AFF),
    this.secondaryColor = const Color(0xFF5856D6),
    this.successColor = const Color(0xFF34C759),
    this.warningColor = const Color(0xFFFF9500),
    this.errorColor = const Color(0xFFFF3B30),
    this.backgroundColor = const Color(0xFFF5F5F7),
    this.surfaceColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF1A1A1A),
    this.textSecondaryColor = const Color(0xFF5F6368),
    this.borderColor = const Color(0xFFE1E1E1),
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final Color textSecondaryColor;
  final Color borderColor;

  // Computed colors
  Color get primaryLight =>
      Color.lerp(primaryColor, Colors.white, 0.3) ?? primaryColor;
  Color get primaryDark =>
      Color.lerp(primaryColor, Colors.black, 0.2) ?? primaryColor;
  Color get surfaceVariant =>
      Color.lerp(surfaceColor, backgroundColor, 0.5) ?? backgroundColor;
  Color get waveformActive => primaryColor;
  Color get waveformInactive =>
      Color.lerp(primaryColor, Colors.white, 0.8) ?? const Color(0xFFD1D1D6);
  Color get waveformThumb => primaryColor;
  Color get playButton => primaryColor;
  Color get playButtonPressed => primaryDark;

  WavePlayerTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? textColor,
    Color? textSecondaryColor,
    Color? borderColor,
  }) {
    return WavePlayerTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textColor: textColor ?? this.textColor,
      textSecondaryColor: textSecondaryColor ?? this.textSecondaryColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }
}

/// Default theme instance
const WavePlayerTheme defaultTheme = WavePlayerTheme();

/// Legacy compatibility - keeping old names for backward compatibility
class WavePlayerColors {
  static WavePlayerTheme _theme = defaultTheme;

  static WavePlayerTheme get theme => _theme;
  static void setTheme(WavePlayerTheme theme) => _theme = theme;

  // Primary colors
  static Color get primary => _theme.primaryColor;
  static Color get primaryLight => _theme.primaryLight;
  static Color get primaryDark => _theme.primaryDark;
  static Color get primary70 =>
      Color.lerp(_theme.primaryColor, Colors.white, 0.3) ?? _theme.primaryColor;
  static Color get primary50 =>
      Color.lerp(_theme.primaryColor, Colors.white, 0.5) ?? _theme.primaryColor;
  static Color get primary30 =>
      Color.lerp(_theme.primaryColor, Colors.white, 0.7) ?? _theme.primaryColor;
  static Color get primary10 =>
      Color.lerp(_theme.primaryColor, Colors.white, 0.9) ?? _theme.primaryColor;

  // Secondary colors
  static Color get secondary => _theme.secondaryColor;

  // Semantic colors
  static Color get success => _theme.successColor;
  static Color get warning => _theme.warningColor;
  static Color get error => _theme.errorColor;
  static Color get info => _theme.primaryColor;

  // Background colors
  static Color get background => _theme.backgroundColor;
  static Color get surface => _theme.surfaceColor;
  static Color get surfaceVariant => _theme.surfaceVariant;

  // Text colors
  static Color get textPrimary => _theme.textColor;
  static Color get textSecondary => _theme.textSecondaryColor;
  static Color get textOnPrimary => Colors.white;

  // Audio player specific colors
  static Color get audioBackground => _theme.backgroundColor;
  static Color get audioSurface => _theme.surfaceColor;
  static Color get audioBorder => _theme.borderColor;
  static Color get waveformActive => _theme.waveformActive;
  static Color get waveformInactive => _theme.waveformInactive;
  static Color get waveformThumb => _theme.waveformThumb;
  static Color get playButton => _theme.playButton;
  static Color get playButtonPressed => _theme.playButtonPressed;

  // Legacy compatibility
  static Color get white => Colors.white;
  static Color get black => Colors.black;
  static Color get red => _theme.errorColor;
  static Color get green => _theme.successColor;
  static Color get orange => _theme.warningColor;
  static Color get neutral60 => const Color(0xFFAEAEB2);
  static Color get neutral70 => const Color(0xFFC7C7CC);
  static Color get neutral80 => const Color(0xFFD1D1D6);
  static Color get neutral50 => const Color(0xFF8E8E93);
  static Color get neutral10 => const Color(0xFF2C2C2E);
}

/// Text style constants for the wave player package
class WavePlayerTextStyles {
  // Essential text styles only
  static const TextStyle small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static const TextStyle large = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.15,
  );

  // Legacy compatibility
  static const TextStyle regularSmall = small;
  static const TextStyle regularMedium = body;
  static const TextStyle regularLarge = large;
  static const TextStyle smallMedium = small;
  static const TextStyle mediumMedium = bodyMedium;
  static const TextStyle mediumLarge = large;
  static const TextStyle boldLarge = large;
}

/// Legacy compatibility - keeping old names for backward compatibility
class AppColors {
  static Color get main => WavePlayerColors.primary;
  static Color get main_70 => WavePlayerColors.primary70;
  static Color get main_50 => WavePlayerColors.primary50;
  static Color get main_30 => WavePlayerColors.primary30;
  static Color get main_10 => WavePlayerColors.primary10;

  static Color get grey10 => WavePlayerColors.neutral10;
  static Color get grey20 => const Color(0xFF3A3A3C);
  static Color get grey30 => const Color(0xFF48484A);
  static Color get grey50 => const Color(0xFF8E8E93);

  static Color get white => WavePlayerColors.white;
  static Color get body => WavePlayerColors.textSecondary;
  static Color get red => WavePlayerColors.red;

  static Color get neutral0 => Colors.black;
  static Color get neutral7 => const Color(0xFF1C1C1E);
}

class AppTextStyle {
  static TextStyle style(AppTextStyleType type, Color color) {
    switch (type) {
      case AppTextStyleType.body2Bold:
        return WavePlayerTextStyles.bodyMedium.copyWith(color: color);
      case AppTextStyleType.regularMedium:
        return WavePlayerTextStyles.regularMedium.copyWith(color: color);
      case AppTextStyleType.body4:
        return WavePlayerTextStyles.regularSmall.copyWith(color: color);
    }
  }
}

enum AppTextStyleType {
  body2Bold,
  regularMedium,
  body4,
}
