import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

/// Pop up tambah anggota. Mengembalikan nama kalau ditekan "Tambah",
/// atau null kalau dibatalkan.
Future<String?> showAddMemberDialog(
  BuildContext context, {
  required String title, // "Tambah Siswa" atau "Tambah Pengajar"
  required String label, // "Nama siswa" atau "Nama pengajar"
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _AddMemberDialog(title: title, label: label),
  );
}

class _AddMemberDialog extends StatefulWidget {
  final String title;
  final String label;

  const _AddMemberDialog({required this.title, required this.label});

  @override
  State<_AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<_AddMemberDialog> {
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
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.text,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13, color: AppColors.text),
        decoration: InputDecoration(
          labelText: '${widget.label}*',
          hintText: widget.label,
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
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
