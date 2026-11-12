import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';

class MembersTab extends StatelessWidget {
  final KelasController controller;

  const MembersTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final teachers = controller.teachers;
    final students = controller.students;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _MemberSectionCard(title: 'Pengajar', names: teachers),
        const SizedBox(height: 20),
        _MemberSectionCard(title: 'Teman Sekelas', names: students),
      ],
    );
  }
}

/// Satu kartu: judul + jumlah orang di atas, daftar nama di bawahnya.
class _MemberSectionCard extends StatelessWidget {
  final String title;
  final List<String> names;

  const _MemberSectionCard({required this.title, required this.names});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
                Text(
                  '${names.length} Orang',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 1, color: AppColors.text),
            for (final name in names) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 12, color: AppColors.text),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.secondaryText.withValues(alpha: 0.2),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
