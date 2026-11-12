import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/confirm_dialog.dart';
import 'package:path_mobile/ui/dashboard/widgets/class_card.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';

class JoinedClassesView extends StatelessWidget {
  final KelasController controller;
  final List<ClassModel> classes;
  final VoidCallback onJoinClass;
  final void Function(ClassModel data) onOpenClass;
  final Widget? topBar;

  const JoinedClassesView({
    super.key,
    required this.controller,
    required this.classes,
    required this.onJoinClass,
    required this.onOpenClass,
    this.topBar,
  });

  Future<void> _confirmLeave(BuildContext context, ClassModel data) async {
    final yes = await showConfirmDialog(
      context,
      title: 'Batalkan Pendaftaran',
      message: 'Apakah anda yakin ingin membatalkan pendaftaran',
    );
    if (yes) {
      controller.leaveClass(data);
    }
  }

  Widget _buildDefaultHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Text(
            'Kelas Terdaftar',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onJoinClass,
            icon: const Icon(Icons.add_box_outlined, size: 18),
            label: const Text('Gabung Kelas'),
            style: AppButtonStyles.softCompact,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topBar ?? _buildDefaultHeader(context),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 152,
            ),
            itemCount: classes.length,
            itemBuilder: (context, index) => ClassCard(
              data: classes[index],
              onTap: () => onOpenClass(classes[index]),
              menuLabel: 'Batalkan Pendaftaran',
              onMenuSelected: () => _confirmLeave(context, classes[index]),
            ),
          ),
        ),
      ],
    );
  }
}
