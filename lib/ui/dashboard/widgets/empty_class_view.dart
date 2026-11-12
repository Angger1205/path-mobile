import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_assets.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class EmptyClassView extends StatelessWidget {
  final String message;
  final String? hint;
  final VoidCallback? onJoinClass;
  final VoidCallback? onAddClass;
  final String joinLabel; // tulisan tombol utama

  const EmptyClassView({
    super.key,
    required this.message,
    this.hint,
    this.onJoinClass,
    this.onAddClass,
    this.joinLabel = 'Gabung Kelas',
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 3,
              color: AppColors.card,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        AppAssets.emptyClass,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    if (hint != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        hint!,
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 220,
              child: FilledButton(
                onPressed: onJoinClass,
                child: Text(joinLabel),
              ),
            ),
            if (onAddClass != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: 220,
                child: OutlinedButton(
                  onPressed: onAddClass,
                  child: const Text('Tambah Kelas'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
