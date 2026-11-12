import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

/// Membuka pop up Edit Materi. Mengembalikan judul + deskripsi baru
/// kalau ditekan Simpan, atau null kalau dibatalkan.
Future<({String title, String description})?> showEditMateriDialog(
  BuildContext context, {
  required String className,
  required String title,
  required String description,
}) {
  return showDialog<({String title, String description})>(
    context: context,
    builder: (_) => _EditMateriDialog(
      className: className,
      initialTitle: title,
      initialDescription: description,
    ),
  );
}

class _EditMateriDialog extends StatefulWidget {
  final String className;
  final String initialTitle;
  final String initialDescription;

  const _EditMateriDialog({
    required this.className,
    required this.initialTitle,
    required this.initialDescription,
  });

  @override
  State<_EditMateriDialog> createState() => _EditMateriDialogState();
}

class _EditMateriDialogState extends State<_EditMateriDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  bool get _canSave => _titleController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.className,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Edit Judul',
              style: TextStyle(fontSize: 10, color: AppColors.secondaryText),
            ),
            TextField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 16, color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Edit judul materi disini',
                isDense: true,
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Edit Deskripsi',
              style: TextStyle(fontSize: 10, color: AppColors.secondaryText),
            ),
            TextField(
              controller: _descController,
              minLines: 8,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 12, color: AppColors.text),
              decoration: const InputDecoration(
                hintText: 'Edit deskripsi materi disini',
                isDense: true,
                filled: false,
                border: InputBorder.none,
              ),
            ),
            const Divider(color: AppColors.text, height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: AppColors.text),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: _canSave
                      ? () => Navigator.pop(context, (
                          title: _titleController.text.trim(),
                          description: _descController.text.trim(),
                        ))
                      : null,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.color1,
                    disabledForegroundColor: AppColors.secondaryText.withValues(
                      alpha: 0.4,
                    ),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
