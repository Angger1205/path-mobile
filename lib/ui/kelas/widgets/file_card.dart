import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

/// Kartu satu file lampiran: nama file + jenisnya di kiri, ikon file di kanan.
class FileCard extends StatelessWidget {
  final String fileName;
  final String fileType; // contoh: 'PDF'
  final VoidCallback? onTap;
  final IconData icon; // ikon di kanan (file atau link)

  const FileCard({
    super.key,
    required this.fileName,
    required this.fileType,
    this.onTap,
    this.icon = Icons.description_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fileName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          color: AppColors.text,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fileType,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                width: 1,
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: AppColors.secondaryText.withValues(alpha: 0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Center(
                  child: Icon(icon, size: 30, color: AppColors.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
