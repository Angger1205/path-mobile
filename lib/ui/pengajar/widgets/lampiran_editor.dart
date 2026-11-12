import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/kelas/widgets/add_link_dialog.dart';
import 'package:path_mobile/ui/pengajar/widgets/lampiran_card.dart';

/// Kotak "Lampiran": daftar lampiran (dengan tombol ✕) + tombol File dan Link.
class LampiranEditor extends StatelessWidget {
  final List<LampiranModel> items;
  final ValueChanged<List<LampiranModel>> onChanged;

  const LampiranEditor({
    super.key,
    required this.items,
    required this.onChanged,
  });

  Future<void> _pickFiles(BuildContext context) async {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty || !context.mounted) return;

    final added = <LampiranModel>[];
    for (final f in files) {
      final bytes = await f.readAsBytes();
      added.add(
        LampiranModel(
          type: LampiranType.file,
          name: f.name,
          detail: f.name.contains('.')
              ? f.name.split('.').last.toUpperCase()
              : 'FILE',
          bytes: bytes,
        ),
      );
    }
    if (!context.mounted) return;
    onChanged([...items, ...added]);
  }

  Future<void> _addLink(BuildContext context) async {
    final link = await showAddLinkDialog(context);
    if (link == null || !context.mounted) return;

    onChanged([
      ...items,
      LampiranModel(type: LampiranType.link, name: 'Link', detail: link),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lampiran',
              style: TextStyle(fontSize: 11, color: AppColors.text),
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < items.length; i++) ...[
              Row(
                children: [
                  Expanded(child: LampiranCard(data: items[i])),
                  IconButton(
                    tooltip: 'Hapus lampiran',
                    onPressed: () => onChanged([...items]..removeAt(i)),
                    icon: const Icon(Icons.close, color: AppColors.text),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: AppButtonStyles.softCompact,
                    onPressed: () => _pickFiles(context),
                    icon: const Icon(Icons.description_outlined, size: 18),
                    label: const Text('File'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: AppButtonStyles.softCompact,
                    onPressed: () => _addLink(context),
                    icon: const Icon(Icons.link, size: 18),
                    label: const Text('Link'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
