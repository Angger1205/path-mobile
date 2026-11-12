import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/data/pengajar/tugas_pengajar_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/pengajar_tugas_detail_screen.dart';
import 'package:path_mobile/ui/pengajar/widgets/lampiran_editor.dart';
import 'package:path_mobile/utils/date_format.dart';

class TugasFormScreen extends StatefulWidget {
  final PengajarController controller;
  final ClassModel classData;
  final TugasPengajarModel? existing;

  const TugasFormScreen({
    super.key,
    required this.controller,
    required this.classData,
    this.existing,
  });

  @override
  State<TugasFormScreen> createState() => _TugasFormScreenState();
}

class _TugasFormScreenState extends State<TugasFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  DateTime? _dueDate;
  bool _accept = true;
  List<LampiranModel> _lampiran = [];

  bool get _isEdit => widget.existing != null;
  bool get _canSave => _titleController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final t = widget.existing;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _dueDate = t?.dueDate;
    _accept = t?.acceptSubmissions ?? true;
    _lampiran = List.of(t?.lampiran ?? const []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate ?? now),
    );
    if (time == null || !mounted) return;

    setState(() {
      _dueDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final existing = widget.existing;

    if (existing == null) {
      final tugas = TugasPengajarModel(
        id: DateTime.now().microsecondsEpochString,
        title: title,
        description: desc,
        author: 'Pengajar',
        postedAt: DateTime.now(),
        dueDate: _dueDate,
        lampiran: List.of(_lampiran),
      );
      final savedId = await widget.controller.addTugas(widget.classData, tugas);
      if (!mounted) return;

      replacePage(
        context,
        breadcrumb: ['Pengajar', widget.classData.title, tugas.title],
        page: PengajarTugasDetailScreen(
          controller: widget.controller,
          classData: widget.classData,
          tugasId: savedId,
        ),
      );
    } else {
      await widget.controller.updateTugas(
        widget.classData,
        existing.withEdits(
          title: title,
          description: desc,
          dueDate: _dueDate,
          acceptSubmissions: _accept,
          lampiran: List.of(_lampiran),
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BackTitleRow(title: _isEdit ? 'Edit Tugas' : 'Tambah Tugas'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isEdit)
                  const Text(
                    'Edit Judul',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.secondaryText,
                    ),
                  ),
                TextField(
                  controller: _titleController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 16, color: AppColors.text),
                  decoration: _underline('Ketikkan judul tugas', 16),
                ),
                if (!_canSave)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Isian wajib diisi',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                if (_isEdit)
                  const Text(
                    'Edit Deskripsi',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.secondaryText,
                    ),
                  ),
                TextField(
                  controller: _descController,
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 12, color: AppColors.text),
                  decoration: _underline('Deskripsi petunjuk (opsional)', 12),
                ),
                if (_isEdit) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Switch(
                        value: _accept,
                        onChanged: (v) => setState(() => _accept = v),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Menerima kiriman',
                        style: TextStyle(fontSize: 11, color: AppColors.text),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                _buildDeadlineField(),
                const SizedBox(height: 16),
                LampiranEditor(
                  items: _lampiran,
                  onChanged: (v) => setState(() => _lampiran = v),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _canSave ? _save : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineField() {
    final hint = _isEdit
        ? 'Edit Tenggat Waktu (opsional)'
        : 'Tenggat Waktu (opsional)';
    final label = _dueDate == null
        ? hint
        : '${formatTanggal(_dueDate!)}, ${formatJam(_dueDate!)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tenggat waktu',
          style: TextStyle(fontSize: 10, color: AppColors.secondaryText),
        ),
        Row(
          children: [
            InkWell(
              onTap: _pickDueDate,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.secondaryText),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Icon(Icons.keyboard_arrow_down, size: 18),
                  ],
                ),
              ),
            ),
            if (_dueDate != null)
              IconButton(
                tooltip: 'Hapus tenggat',
                onPressed: () => setState(() => _dueDate = null),
                icon: const Icon(Icons.close, size: 16),
              ),
          ],
        ),
      ],
    );
  }

  InputDecoration _underline(String hint, double size) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: size, color: AppColors.secondaryText),
      isDense: true,
      filled: false,
      border: const UnderlineInputBorder(),
    );
  }
}

extension on DateTime {
  String get microsecondsEpochString => microsecondsSinceEpoch.toString();
}
