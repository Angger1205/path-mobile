import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class CreateClassForm extends StatefulWidget {
  final void Function(String name, String grade) onCreate;
  final VoidCallback onCancel;
  final String title; // "Buat Kelas" atau "Edit Kelas"
  final String submitLabel; // "Buat" atau "Simpan"
  final String initialName;
  final String initialGrade;

  const CreateClassForm({
    super.key,
    required this.onCreate,
    required this.onCancel,
    this.title = 'Buat Kelas',
    this.submitLabel = 'Buat',
    this.initialName = '',
    this.initialGrade = '',
  });

  @override
  State<CreateClassForm> createState() => _CreateClassFormState();
}

class _CreateClassFormState extends State<CreateClassForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _gradeController;

  bool get _canCreate => _nameController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _gradeController = TextEditingController(text: widget.initialGrade);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onCreate(
      _nameController.text.trim(),
      _gradeController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              color: AppColors.card,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.co_present,
                          size: 28,
                          color: AppColors.text,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            onChanged: (_) => setState(() {}),
                            decoration: _fieldStyle('Nama Kelas'),
                          ),
                        ),
                      ],
                    ),
                    if (!_canCreate)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          '*Wajib diisi',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _gradeController,
                      decoration: _fieldStyle('Kelas'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: widget.onCancel,
                  style: TextButton.styleFrom(foregroundColor: AppColors.text),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: AppButtonStyles.softCompact,
                  onPressed: _canCreate ? _submit : null,
                  child: Text(widget.submitLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: false,
      border: const UnderlineInputBorder(),
    );
  }
}
