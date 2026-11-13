import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/pengajar/tugas_pengajar_model.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kelas/widgets/post_card.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/pengajar_tugas_detail_screen.dart';
import 'package:path_mobile/ui/pengajar/tugas_form_screen.dart';

class PengajarTugasTab extends StatelessWidget {
  final PengajarController controller;
  final ClassModel classData;

  const PengajarTugasTab({
    super.key,
    required this.controller,
    required this.classData,
  });

  void _openForm(BuildContext context, {TugasPengajarModel? existing}) {
    openPage(
      context,
      breadcrumb: [
        'Pengajar',
        classData.title,
        'Tugas',
        existing == null ? 'Buat Tugas' : 'Edit Tugas',
      ],
      page: TugasFormScreen(
        controller: controller,
        classData: classData,
        existing: existing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final items = controller.tugasOf(classData);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  style: AppButtonStyles.softCompact,
                  onPressed: () => _openForm(context),
                  icon: const Icon(
                    Icons.add_box_outlined,
                    size: 18,
                  ),
                  label: const Text('Tambah Tugas'),
                ),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada tugas',
                        style: TextStyle(color: AppColors.secondaryText),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final t = items[i];
                        return PostCard(
                          icon: Icons.list_alt_outlined,
                          label: 'Tugas Baru:',
                          title: t.title,
                          date: t.postedAt,
                          onTap: () => openPage(
                            context,
                            breadcrumb: ['Pengajar', classData.title, t.title],
                            page: PengajarTugasDetailScreen(
                              controller: controller,
                              classData: classData,
                              tugasId: t.id,
                            ),
                          ),
                          menuLabels: const ['Edit'],
                          onMenuItemSelected: (_) =>
                              _openForm(context, existing: t),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
