import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/confirm_dialog.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/widgets/add_member_dialog.dart';

class PengajarMembersTab extends StatelessWidget {
  final PengajarController controller;
  final ClassModel classData;

  const PengajarMembersTab({
    super.key,
    required this.controller,
    required this.classData,
  });

  Future<void> _add(BuildContext context, {required bool isTeacher}) async {
    final name = await showAddMemberDialog(
      context,
      title: isTeacher ? 'Tambah Pengajar' : 'Tambah Siswa',
      label: isTeacher ? 'Nama pengajar' : 'Nama siswa',
    );
    if (name == null || !context.mounted) return;

    final ok = isTeacher
        ? controller.addTeacher(classData, name)
        : controller.addStudent(classData, name);

    if (!ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Nama sudah ada di kelas')),
        );
    }
  }

  Future<void> _remove(
    BuildContext context, {
    required bool isTeacher,
    required String name,
  }) async {
    final yes = await showConfirmDialog(
      context,
      title: isTeacher ? 'Keluarkan Pengajar' : 'Keluarkan Siswa',
      message: 'Apakah anda yakin ingin mengeluarkan $name dari kelas',
    );
    if (!yes) return;

    if (isTeacher) {
      controller.removeTeacher(classData, name);
    } else {
      controller.removeStudent(classData, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _buildSection(
              context,
              isTeacher: true,
              names: controller.teachersOf(classData),
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              isTeacher: false,
              names: controller.studentsOf(classData),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required bool isTeacher,
    required List<String> names,
  }) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 6),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTeacher ? 'Pengajar' : 'Siswa',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${names.length} Orang',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  style: AppButtonStyles.softCompact,
                  onPressed: () => _add(context, isTeacher: isTeacher),
                  icon: Icon(
                    isTeacher ? Icons.co_present : Icons.person_outline,
                    size: 16,
                  ),
                  label: Text(
                    isTeacher ? 'Tambah Pengajar' : 'Tambah Siswa',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1, color: AppColors.text),
            if (names.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  isTeacher ? 'Belum ada pengajar' : 'Belum ada siswa',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            for (var i = 0; i < names.length; i++) ...[
              _buildRow(
                context,
                isTeacher: isTeacher,
                canRemove: !(isTeacher && i == 0),
                name: names[i],
              ),
              if (i < names.length - 1)
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

  Widget _buildRow(
    BuildContext context, {
    required bool isTeacher,
    required bool canRemove,
    required String name,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 12, color: AppColors.text),
            ),
          ),
          SizedBox(
            width: 24,
            height: 24,
            child: canRemove
                ? PopupMenuButton<int>(
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                    icon: const Icon(Icons.more_vert, color: AppColors.text),
                    tooltip: 'Opsi anggota',
                    color: AppColors.background,
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (_) =>
                        _remove(context, isTeacher: isTeacher, name: name),
                    itemBuilder: (context) => const [
                      PopupMenuItem<int>(value: 0, child: Text('Keluarkan')),
                    ],
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
