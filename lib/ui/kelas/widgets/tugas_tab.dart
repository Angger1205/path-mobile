import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/tugas_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';
import 'package:path_mobile/ui/kelas/tugas_detail_screen.dart';
import 'package:path_mobile/ui/kelas/widgets/post_card.dart';

class TugasTab extends StatelessWidget {
  final KelasController controller;
  final List<String> breadcrumb;

  const TugasTab({
    super.key,
    required this.controller,
    required this.breadcrumb,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final all = controller.tugasItems;

        if (all.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada tugas',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          );
        }

        final assigned = all.where((t) => !t.isMissing).toList();
        final missing = all.where((t) => t.isMissing).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            if (assigned.isNotEmpty)
              ..._buildSection(context, 'Assigned', assigned),
            if (assigned.isNotEmpty && missing.isNotEmpty)
              const SizedBox(height: 14),
            if (missing.isNotEmpty)
              ..._buildSection(context, 'Missing', missing),
          ],
        );
      },
    );
  }

  List<Widget> _buildSection(
    BuildContext context,
    String title,
    List<TugasModel> items,
  ) {
    return [
      Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          decoration: TextDecoration.underline,
          color: AppColors.text,
        ),
      ),
      const SizedBox(height: 12),
      for (final tugas in items) ...[
        PostCard(
          icon: Icons.list_alt_outlined,
          label: 'Tugas Baru:',
          title: tugas.title,
          date: tugas.postedAt,
          onTap: () => openPage(
            context,
            breadcrumb: [...breadcrumb, tugas.title],
            page: TugasDetailScreen(
              controller: controller,
              tugasId: tugas.id,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    ];
  }
}
