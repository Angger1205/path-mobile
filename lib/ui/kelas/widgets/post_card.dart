import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/utils/date_format.dart';

/// Cetakan umum untuk kartu "Materi Baru:" dan "Tugas Baru:".
class PostCard extends StatelessWidget {
  final IconData icon; // ikon di kiri
  final String label; // "Materi Baru:" atau "Tugas Baru:"
  final String title;
  final DateTime date;
  final VoidCallback? onTap;
  final List<String>? menuLabels; // pilihan menu titik tiga, null = tanpa menu
  final void Function(int index)? onMenuItemSelected;

  const PostCard({
    super.key,
    required this.icon,
    required this.label,
    required this.title,
    required this.date,
    this.onTap,
    this.menuLabels,
    this.onMenuItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, size: 22, color: AppColors.text),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        Text(
                          formatTanggal(date),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        if (_hasMenu) ...[
                          const SizedBox(width: 4),
                          _buildMenu(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.text,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasMenu => menuLabels != null && onMenuItemSelected != null;

  Widget _buildMenu() {
    return SizedBox(
      width: 24,
      height: 24,
      child: PopupMenuButton<int>(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: const Icon(Icons.more_vert, color: AppColors.text),
        tooltip: 'Opsi',
        color: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: onMenuItemSelected!,
        itemBuilder: (context) => [
          for (var i = 0; i < menuLabels!.length; i++)
            PopupMenuItem<int>(value: i, child: Text(menuLabels![i])),
        ],
      ),
    );
  }
}
