import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/pengajar/pengumpulan_model.dart';
import 'package:path_mobile/ui/core/app_routes.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kelas/widgets/file_card.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/widgets/pengumpulan_checklist.dart';

class KonfirmasiKoreksiAiScreen extends StatefulWidget {
  final PengajarController controller;
  final ClassModel classData;
  final String tugasId;
  final List<PengumpulanModel> students;
  final Map<String, int> results;

  const KonfirmasiKoreksiAiScreen({
    super.key,
    required this.controller,
    required this.classData,
    required this.tugasId,
    required this.students,
    required this.results,
  });

  @override
  State<KonfirmasiKoreksiAiScreen> createState() =>
      _KonfirmasiKoreksiAiScreenState();
}

class _KonfirmasiKoreksiAiScreenState extends State<KonfirmasiKoreksiAiScreen> {
  Set<String> _accepted = {};

  void _accept() {
    final messenger = ScaffoldMessenger.of(context);

    widget.controller.saveScores(widget.tugasId, {
      for (final name in _accepted) name: widget.results[name] ?? 0,
    });

    Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.cekJawaban));

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Koreksi AI diterima')));
  }

  @override
  Widget build(BuildContext context) {
    final tugas = widget.controller.tugasById(
      widget.classData,
      widget.tugasId,
    );
    final title = tugas?.title ?? 'Tugas';

    return Column(
      children: [
        const BackTitleRow(title: 'Koreksi Menggunakan AI'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 12),
              FileCard(fileName: 'Rekap koreksi AI_$title', fileType: 'PDF'),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: _accepted.isEmpty ? null : _accept,
                  style: FilledButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text('Terima Koreksi'),
                ),
              ),
              const SizedBox(height: 12),
              PengumpulanChecklist(
                students: widget.students,
                selected: _accepted,
                scores: widget.results,
                maxScore: tugas?.points ?? 100,
                onChanged: (v) => setState(() => _accepted = v),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
