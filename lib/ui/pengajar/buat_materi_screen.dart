import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/ui/core/app_routes.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/pengajar/buat_materi_ai_screen.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/widgets/lampiran_editor.dart';

class BuatMateriScreen extends StatefulWidget {
  final PengajarController controller;
  final ClassModel classData;
  final String initialTitle;
  final String initialDescription;
  final List<LampiranModel> initialLampiran;

  const BuatMateriScreen({
    super.key,
    required this.controller,
    required this.classData,
    this.initialTitle = '',
    this.initialDescription = '',
    this.initialLampiran = const [],
  });

  @override
  State<BuatMateriScreen> createState() => _BuatMateriScreenState();
}

class _BuatMateriScreenState extends State<BuatMateriScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  List<LampiranModel> _lampiran = [];

  bool get _canSave => _titleController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDescription);
    _lampiran = List.of(widget.initialLampiran);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await widget.controller.addMateri(
      widget.classData,
      MateriModel(
        title: _titleController.text.trim(),
        author: 'Pengajar',
        postedAt: DateTime.now(),
        description: _descController.text.trim(),
        lampiran: List.of(_lampiran),
      ),
    );
    if (!mounted) return;
    Navigator.of(context).popUntil(
      ModalRoute.withName(AppRoutes.pengajarDetail),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BackTitleRow(title: 'Buat Materi'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 16, color: AppColors.text),
                  decoration: _underline('Ketikkan judul materi', 16),
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
                TextField(
                  controller: _descController,
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 12, color: AppColors.text),
                  decoration: _underline('Deskripsi materi (opsional)', 12),
                ),
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
                const SizedBox(height: 8),
                const Text(
                  'Atau buat otomatis menggunakan AI',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => openPage(
                    context,
                    breadcrumb: [
                      'Pengajar',
                      widget.classData.title,
                      'Buat Materi',
                    ],
                    page: BuatMateriAiScreen(
                      controller: widget.controller,
                      classData: widget.classData,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Buat materi dengan AI',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
