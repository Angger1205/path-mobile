import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

/// Menampilkan dialog "Tambahkan link".
/// Hasilnya: tulisan link kalau pengguna menekan "Tambah link",
/// atau kosong (null) kalau pengguna menekan "Batal".
Future<String?> showAddLinkDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const _AddLinkDialog(),
  );
}

class _AddLinkDialog extends StatefulWidget {
  const _AddLinkDialog();

  @override
  State<_AddLinkDialog> createState() => _AddLinkDialogState();
}

class _AddLinkDialogState extends State<_AddLinkDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canAdd = _controller.text.trim().isNotEmpty;

    return AlertDialog(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Tambahkan link',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.url,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13, color: AppColors.text),
        decoration: const InputDecoration(
          labelText: 'Link*',
          hintText: 'Link',
          helperText: '*Wajib diisi',
          isDense: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: AppColors.text),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: canAdd
              ? () => Navigator.pop(context, _controller.text.trim())
              : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.color1,
            disabledForegroundColor: AppColors.secondaryText.withValues(
              alpha: 0.4,
            ),
          ),
          child: const Text('Tambah link'),
        ),
      ],
    );
  }
}
