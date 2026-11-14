import 'package:flutter/material.dart';

abstract final class AppColors {
  // Status / Semantic Colors
  static const Color info = Color(0xFF4285F4);
  static const Color success = Color(0xFF38D462);
  static const Color warning = Color(0xFFFFCA30);
  static const Color error = Color(0xFFFF584A);

  // Surface & Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color card = Color(0xFFFFFFFF);

  // Typography Colors
  static const Color text = Color(0xFF202124);
  static const Color secondaryText = Color(0xFF5F6368);

  // Brand / Palette Colors
  static const Color color1 = Color(0xFF4285F4);
  static const Color color2 = Color(0xFF7FAEFC);
  static const Color color3 = Color(0xFF164DA8);
}

@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  const AppCustomColors({
    required this.info,
    required this.success,
    required this.warning,
    required this.error,
    required this.secondaryText,
    required this.color1,
    required this.color2,
    required this.color3,
  });

  final Color info;
  final Color success;
  final Color warning;
  final Color error;
  final Color secondaryText;
  final Color color1;
  final Color color2;
  final Color color3;

  static const light = AppCustomColors(
    info: AppColors.info,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    secondaryText: AppColors.secondaryText,
    color1: AppColors.color1,
    color2: AppColors.color2,
    color3: AppColors.color3,
  );

  @override
  AppCustomColors copyWith({
    Color? info,
    Color? success,
    Color? warning,
    Color? error,
    Color? secondaryText,
    Color? color1,
    Color? color2,
    Color? color3,
  }) {
    return AppCustomColors(
      info: info ?? this.info,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      secondaryText: secondaryText ?? this.secondaryText,
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      color3: color3 ?? this.color3,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      info: Color.lerp(info, other.info, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      color1: Color.lerp(color1, other.color1, t)!,
      color2: Color.lerp(color2, other.color2, t)!,
      color3: Color.lerp(color3, other.color3, t)!,
    );
  }
}

abstract final class AppTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: AppColors.color1,
      onPrimary: Colors.white,
      primaryContainer: AppColors.color2,
      onPrimaryContainer: AppColors.color3,
      secondary: AppColors.color2,
      onSecondary: AppColors.text,
      tertiary: AppColors.color3,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.card,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.secondaryText,
    );

    final baseTextTheme = ThemeData.light().textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.card,
      cardTheme: const CardThemeData(
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.color1,
        unselectedItemColor: AppColors.secondaryText,
      ),
      textTheme: baseTextTheme.copyWith(
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: AppColors.text),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: AppColors.secondaryText,
        ),
        labelMedium: baseTextTheme.labelMedium?.copyWith(
          color: AppColors.secondaryText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.color1,
          foregroundColor: Colors.white,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.color1,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.color2.withValues(alpha: 0.6),
          disabledForegroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.color1,
          side: BorderSide(
            color: AppColors.secondaryText.withValues(alpha: 0.4),
          ),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppCustomColors.light,
      ],
    );
  }

  static final ButtonStyle softButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.card,
    foregroundColor: AppColors.text,
    disabledBackgroundColor: AppColors.background,
    disabledForegroundColor: AppColors.secondaryText.withValues(alpha: 0.5),
    elevation: 3,
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
  );

  static final ButtonStyle softCompactButton = ElevatedButton.styleFrom(
    backgroundColor: AppColors.card,
    foregroundColor: AppColors.text,
    disabledBackgroundColor: AppColors.background,
    disabledForegroundColor: AppColors.secondaryText.withValues(alpha: 0.5),
    elevation: 3,
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  );
}
