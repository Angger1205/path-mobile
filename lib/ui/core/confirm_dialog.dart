import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

/// Menampilkan dialog konfirmasi dengan tombol Tidak dan Ya.
/// Hasilnya true kalau pengguna menekan "Ya", selain itu false.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.secondaryText,
          fontSize: 12,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          style: AppButtonStyles.softCompact,
          child: const Text('Tidak'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: AppButtonStyles.softCompact,
          child: const Text('Ya'),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Dialog pemberitahuan dengan satu tombol "Oke".
Future<void> showInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.secondaryText,
          fontSize: 12,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: AppButtonStyles.softCompact,
          child: const Text('Oke'),
        ),
      ],
    ),
  );
}
