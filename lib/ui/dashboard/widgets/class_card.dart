import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/ui/core/app_assets.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class ClassCard extends StatelessWidget {
  final ClassModel data;
  final VoidCallback? onTap;
  final String? menuLabel; // tulisan pilihan di menu titik tiga
  final VoidCallback? onMenuSelected; // aksi saat pilihan itu ditekan
  final List<String>? menuLabels; // daftar pilihan menu (versi banyak pilihan)
  final void Function(int index)? onMenuItemSelected; // index pilihan yang ditekan

  const ClassCard({
    super.key,
    required this.data,
    this.onTap,
    this.menuLabel,
    this.onMenuSelected,
    this.menuLabels,
    this.onMenuItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias, // supaya gambar ikut terpotong sudut bulat
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian sampul Material bergaya banner Google Classroom
            SizedBox(height: 70, width: double.infinity, child: _buildImage()),
            // Bagian teks + titik tiga
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.text,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          data.grade,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.secondaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Hanya tampil kalau teacher tidak kosong
                        if (data.teacher != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            data.teacher!,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.secondaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  _buildMenu(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    // Versi banyak pilihan (dipakai tab Pengajar)
    if (menuLabels != null && onMenuItemSelected != null) {
      return _popup(
        items: [
          for (var i = 0; i < menuLabels!.length; i++)
            PopupMenuItem<int>(value: i, child: Text(menuLabels![i])),
        ],
        onSelected: onMenuItemSelected!,
      );
    }

    // Versi satu pilihan
    if (onMenuSelected == null) {
      return const Icon(
        Icons.more_vert,
        size: 20,
        color: AppColors.secondaryText,
      );
    }

    return _popup(
      items: [PopupMenuItem<int>(value: 0, child: Text(menuLabel ?? ''))],
      onSelected: (_) => onMenuSelected!(),
    );
  }

  // Tombol titik tiga + gaya popup, dipakai kedua versi di atas
  Widget _popup({
    required List<PopupMenuItem<int>> items,
    required void Function(int) onSelected,
  }) {
    return SizedBox(
      width: 28,
      height: 28,
      child: PopupMenuButton<int>(
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: const Icon(Icons.more_vert, color: AppColors.text),
        tooltip: 'Opsi kelas',
        color: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: onSelected,
        itemBuilder: (context) => items,
      ),
    );
  }

  Widget _buildImage() {
    final theme = AppAssets.getCoverTheme(
      data.coverIndex ?? data.title.hashCode,
    );
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.color1, theme.color2],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              theme.icon,
              size: 68,
              color: Colors.white.withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            left: 14,
            top: 17,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withValues(alpha: 0.22),
              child: Icon(
                theme.icon,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
