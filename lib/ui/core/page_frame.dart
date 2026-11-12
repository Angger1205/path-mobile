import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

/// Bingkai tiap halaman: breadcrumb "PATH > ..." di atas, isi halaman di bawah.
class PageFrame extends StatelessWidget {
  final List<String> breadcrumb; // contoh: ['Kelas', 'Mapel 1']
  final Widget child;

  const PageFrame({super.key, required this.breadcrumb, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      child: SafeArea(
        bottom: false, // bagian bawah sudah diurus navbar
        child: Column(
          children: [
            _buildBreadcrumb(),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          const Text(
            'PATH',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          for (final item in breadcrumb) ...[
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.secondaryText,
            ),
            Flexible(
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.text,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Membuka halaman baru di dalam menu yang sedang aktif (navbar tetap tampil).
void openPage(
  BuildContext context, {
  required List<String> breadcrumb,
  required Widget page,
  String? routeName, // nama halaman, boleh kosong
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => PageFrame(breadcrumb: breadcrumb, child: page),
    ),
  );
}

/// Mengganti halaman yang sedang tampil (tombol kembali tidak kembali ke sini).
void replacePage(
  BuildContext context, {
  required List<String> breadcrumb,
  required Widget page,
}) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => PageFrame(breadcrumb: breadcrumb, child: page),
    ),
  );
}

/// Baris "← Judul" untuk halaman bagian dalam (detail kelas, detail materi, dll).
/// Halaman awal tiap menu TIDAK memakai ini.
class BackTitleRow extends StatelessWidget {
  final String title;

  const BackTitleRow({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
