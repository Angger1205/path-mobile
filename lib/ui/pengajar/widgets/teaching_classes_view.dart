import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/dashboard/widgets/class_card.dart';

class TeachingClassesView extends StatelessWidget {
  final List<ClassModel> classes;
  final VoidCallback onCreate;
  final void Function(ClassModel) onOpen;
  final void Function(ClassModel) onCopyLink;

  const TeachingClassesView({
    super.key,
    required this.classes,
    required this.onCreate,
    required this.onOpen,
    required this.onCopyLink,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kelas',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              ElevatedButton.icon(
                style: AppButtonStyles.softCompact,
                onPressed: onCreate,
                icon: const Icon(Icons.add_box_outlined, size: 18),
                label: const Text('Buat Kelas'),
              ),
            ],
          ),
        ),
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
            itemBuilder: (context, i) {
              final item = classes[i];
              return ClassCard(
                data: item,
                onTap: () => onOpen(item),
                menuLabel: 'Salin link undangan kelas',
                onMenuSelected: () => onCopyLink(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
