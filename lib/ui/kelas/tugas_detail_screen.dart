import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/tugas_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';
import 'package:path_mobile/ui/kelas/widgets/post_card.dart';
import 'package:path_mobile/ui/kelas/widgets/tugas_submission_card.dart';
import 'package:path_mobile/utils/date_format.dart';

class TugasDetailScreen extends StatelessWidget {
  final KelasController controller;
  final String tugasId;

  const TugasDetailScreen({
    super.key,
    required this.controller,
    required this.tugasId,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final tugas = controller.tugasById(tugasId);

        if (tugas == null) {
          return const Column(
            children: [
              BackTitleRow(title: 'Tugas'),
              Expanded(child: Center(child: Text('Tugas tidak ditemukan'))),
            ],
          );
        }

        final meta =
            '${tugas.author} • ${formatTanggal(tugas.postedAt)} • ${formatJam(tugas.postedAt)}';

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
                    const SizedBox(height: 8),
                    _buildPointsRow(tugas),
                    const SizedBox(height: 14),
                    _buildScoreRow(tugas),
                    const SizedBox(height: 16),
                    Text(
                      tugas.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PostCard(
                      icon: Icons.list_alt_outlined,
                      label: 'Tugas Baru:',
                      title: tugas.title,
                      date: tugas.postedAt,
                    ),
                    const SizedBox(height: 16),
                    TugasSubmissionCard(
                      controller: controller,
                      tugas: tugas,
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

  Widget _buildPointsRow(TugasModel tugas) {
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
          'Tenggat: ${formatTanggal(tugas.dueDate)}',
          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
        ),
      ],
    );
  }

  Widget _buildScoreRow(TugasModel tugas) {
    return Row(
      children: [
        const Text(
          'Nilai',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(width: 28),
        Text(
          '.../${tugas.points}',
          style: const TextStyle(fontSize: 12, color: AppColors.text),
        ),
      ],
    );
  }
}
