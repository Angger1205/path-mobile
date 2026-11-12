import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';
import 'package:path_mobile/ui/kelas/widgets/registered_classes_view.dart';

class DashboardScreen extends StatefulWidget {
  final KelasController controller;

  const DashboardScreen({super.key, required this.controller});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTab = 0; // 0 = Terdaftar, 1 = Pengajar

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      breadcrumb: const ['Beranda'],
      child: _selectedTab == 1
          ? Column(
              children: [
                _buildHeader(),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Belum ada kelas yang Anda ajar',
                      style: TextStyle(color: AppColors.secondaryText),
                    ),
                  ),
                ),
              ],
            )
          : RegisteredClassesView(
              controller: widget.controller,
              breadcrumbRoot: 'Beranda',
              emptyMessage:
                  'Anda belum memiliki kelas atau bergabung ke kelas manapun',
              emptyHint: 'Gabung Kelas atau Tambah Kelas',
              onAddClass: () => context.go('/pengajar'),
              listTopBar: _buildHeader(),
            ),
    );
  }

  // Kepala Beranda: judul (berganti sesuai tab) + dua tombol tab
  Widget _buildHeader() {
    final textTheme = Theme.of(context).textTheme;
    final title = _selectedTab == 0 ? 'Kelas Terdaftar' : 'Pengajar';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTabButton('Terdaftar', 0),
              const SizedBox(width: 12),
              _buildTabButton('Pengajar', 1),
            ],
          ),
        ],
      ),
    );
  }

  // Sesuai desain: tab yang SEDANG dibuka berwarna putih (Outlined),
  // tab tujuan berwarna biru (Filled).
  Widget _buildTabButton(String label, int index) {
    final isCurrent = _selectedTab == index;
    void onPressed() => setState(() => _selectedTab = index);

    return SizedBox(
      width: 110,
      child: isCurrent
          ? OutlinedButton(onPressed: onPressed, child: Text(label))
          : FilledButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
