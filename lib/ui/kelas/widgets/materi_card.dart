import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/ui/kelas/widgets/post_card.dart';

class MateriCard extends StatelessWidget {
  final MateriModel data;
  final VoidCallback? onTap;
  final List<String>? menuLabels;
  final void Function(int index)? onMenuItemSelected;

  const MateriCard({
    super.key,
    required this.data,
    this.onTap,
    this.menuLabels,
    this.onMenuItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PostCard(
      icon: Icons.menu_book_outlined,
      label: 'Materi Baru:',
      title: data.title,
      date: data.postedAt,
      onTap: onTap,
      menuLabels: menuLabels,
      onMenuItemSelected: onMenuItemSelected,
    );
  }
}
