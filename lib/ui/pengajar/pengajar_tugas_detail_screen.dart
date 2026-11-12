import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/pengajar/tugas_pengajar_model.dart';
import 'package:path_mobile/ui/core/app_routes.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/pengajar/cek_jawaban_screen.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/widgets/lampiran_card.dart';
import 'package:path_mobile/utils/date_format.dart';

class PengajarTugasDetailScreen extends StatelessWidget {
  final PengajarController controller;
  final ClassModel classData;
  final String tugasId;

  const PengajarTugasDetailScreen({
    super.key,
    required this.controller,
    required this.classData,
    required this.tugasId,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final tugas = controller.tugasById(classData, tugasId);

        if (tugas == null) {
          return const Column(
            children: [
              BackTitleRow(title: 'Tugas'),
              Expanded(child: Center(child: Text('Tugas tidak ditemukan'))),
            ],
          );
        }

        final meta =
            '${tugas.author} • ${formatJam(tugas.postedAt)} • ${formatTanggal(tugas.postedAt)}';

        return Column(
          children: [
            BackTitleRow(title: tugas.title),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meta,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildPointsRow(tugas),
                    if (tugas.description.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        tugas.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    for (final item in tugas.lampiran) ...[
                      LampiranCard(data: item),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 4),
                    const Text(
                      'AI bisa membantu guru dalam mengecek jawaban siswa',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () => openPage(
                        context,
                        breadcrumb: ['Pengajar', classData.title, tugas.title],
                        page: CekJawabanScreen(
                          controller: controller,
                          classData: classData,
                          tugasId: tugas.id,
                        ),
                        routeName: AppRoutes.cekJawaban,
                      ),
                      style: FilledButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: const Text('Cek jawaban'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPointsRow(TugasPengajarModel tugas) {
    return Row(
      children: [
        Text(
          '${tugas.points} poin',
          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
        ),
        Container(
          width: 1,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: AppColors.secondaryText,
        ),
        Text(
          tugas.dueDate == null
              ? 'Tanpa tenggat'
              : 'Tenggat: ${formatTanggal(tugas.dueDate!)}',
          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
        ),
      ],
    );
  }
}
