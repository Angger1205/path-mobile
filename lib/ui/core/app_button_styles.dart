import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class AppButtonStyles {
  // Tombol putih berbayang berbentuk pil, sesuai desain
  static final ButtonStyle soft = ElevatedButton.styleFrom(
    backgroundColor: AppColors.card,
    foregroundColor: AppColors.text,
    disabledBackgroundColor: AppColors.background,
    disabledForegroundColor: AppColors.secondaryText.withValues(alpha: 0.5),
    elevation: 3,
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
  );

  // Versi lebih kecil: untuk dialog dan tombol di baris judul
  static final ButtonStyle softCompact = ElevatedButton.styleFrom(
    backgroundColor: AppColors.card,
    foregroundColor: AppColors.text,
    disabledBackgroundColor: AppColors.background,
    disabledForegroundColor: AppColors.secondaryText.withValues(alpha: 0.5),
    elevation: 3,
    shape: const StadiumBorder(),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  );
}
