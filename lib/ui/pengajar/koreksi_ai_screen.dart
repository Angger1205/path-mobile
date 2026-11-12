import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/pengajar/konfirmasi_koreksi_ai_screen.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/widgets/pengumpulan_checklist.dart';

class KoreksiAiScreen extends StatefulWidget {
  final PengajarController controller;
  final ClassModel classData;
  final String tugasId;

  const KoreksiAiScreen({
    super.key,
    required this.controller,
    required this.classData,
    required this.tugasId,
  });

  @override
  State<KoreksiAiScreen> createState() => _KoreksiAiScreenState();
}

class _KoreksiAiScreenState extends State<KoreksiAiScreen> {
  PengajarController get _ctrl => widget.controller;
  final _descController = TextEditingController();

  String? _keyFileName;
  Set<String> _selected = {};
  bool _isLoading = false;

  bool get _hasKey =>
      _keyFileName != null || _descController.text.trim().isNotEmpty;

  bool get _canCorrect => _hasKey && _selected.isNotEmpty && !_isLoading;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickKeyFile() async {
    final file = await FilePicker.pickFile();
    if (file == null || !mounted) return;
    setState(() => _keyFileName = file.name);
  }

  Future<void> _correct() async {
    final tugas = _ctrl.tugasById(widget.classData, widget.tugasId);
    if (tugas == null) return;

    final students = _ctrl
        .pengumpulanOf(widget.tugasId)
        .where((p) => _selected.contains(p.studentName))
        .toList();

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    final results = await _ctrl.generateAiKoreksi(students);

    if (!mounted) return;
    setState(() => _isLoading = false);

    openPage(
      context,
      breadcrumb: ['Pengajar', widget.classData.title, tugas.title],
      page: KonfirmasiKoreksiAiScreen(
        controller: _ctrl,
        classData: widget.classData,
        tugasId: widget.tugasId,
        students: students,
        results: results,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tugas = _ctrl.tugasById(widget.classData, widget.tugasId);

    return Column(
      children: [
        const BackTitleRow(title: 'Koreksi Menggunakan AI'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              Text(
                tugas?.title ?? 'Tugas',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(Icons.info, size: 12, color: AppColors.text),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'AI akan membantu mengoreksi pekerjaan siswa menggunakan '
                      'lampiran file kunci jawaban yang sudah diunggah atau buat '
                      'sendiri kunci jawaban menggunakan AI',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Kunci jawaban',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'File',
                style: TextStyle(fontSize: 10, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  ElevatedButton(
                    style: AppButtonStyles.softCompact,
                    onPressed: _pickKeyFile,
                    child: const Text('Upload file'),
                  ),
                  if (_keyFileName != null) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _keyFileName!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.text,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Hapus file',
                      onPressed: () => setState(() => _keyFileName = null),
                      icon: const Icon(Icons.close, size: 16),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Atau buat kunci jawaban menggunakan AI',
                style: TextStyle(fontSize: 10, color: AppColors.secondaryText),
              ),
              TextField(
                controller: _descController,
                onChanged: (_) => setState(() {}),
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontSize: 11, color: AppColors.text),
                decoration: const InputDecoration(
                  hintText: 'Deskripsi kunci jawaban yang akan dibuat AI',
                  hintStyle: TextStyle(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                  ),
                  isDense: true,
                  filled: false,
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Mengoreksi jawaban...',
                      style: TextStyle(fontSize: 11, color: AppColors.text),
                    ),
                  ],
                )
              else
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: _canCorrect ? _correct : null,
                    style: FilledButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text('Koreksi menggunakan AI'),
                  ),
                ),
              const SizedBox(height: 16),
              PengumpulanChecklist(
                students: _ctrl.pengumpulanOf(widget.tugasId),
                selected: _selected,
                maxScore: tugas?.points ?? 100,
                onChanged: (v) => setState(() => _selected = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
