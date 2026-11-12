import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/data/kelas/tugas_model.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';
import 'package:path_mobile/ui/kelas/widgets/add_link_dialog.dart';
import 'package:path_mobile/ui/kelas/widgets/file_card.dart';

/// Kartu "Tugas" di halaman detail tugas: status, lampiran, dan tombol-tombol.
class TugasSubmissionCard extends StatefulWidget {
  final KelasController controller;
  final TugasModel tugas;

  const TugasSubmissionCard({
    super.key,
    required this.controller,
    required this.tugas,
  });

  @override
  State<TugasSubmissionCard> createState() => _TugasSubmissionCardState();
}

class _TugasSubmissionCardState extends State<TugasSubmissionCard> {
  bool _composing = false;
  final List<LampiranModel> _drafts = [];

  TugasModel get _tugas => widget.tugas;

  Future<void> _addLink() async {
    final link = await showAddLinkDialog(context);
    if (link == null || !mounted) return;
    setState(() {
      _drafts.add(
        LampiranModel(type: LampiranType.link, name: 'Link', detail: link),
      );
    });
  }

  Future<void> _addFile() async {
    final files = await FilePicker.pickFiles();
    if (files.isEmpty || !mounted) return;

    final added = <LampiranModel>[];
    for (final f in files) {
      final bytes = await f.readAsBytes();
      final ext = f.name.contains('.')
          ? f.name.split('.').last.toUpperCase()
          : 'FILE';
      added.add(
        LampiranModel(
          type: LampiranType.file,
          name: f.name,
          detail: ext,
          bytes: bytes,
        ),
      );
    }

    if (!mounted) return;
    setState(() => _drafts.addAll(added));
  }

  void _removeDraft(LampiranModel item) {
    setState(() => _drafts.remove(item));
  }

  void _submit() {
    widget.controller.submitTugas(_tugas.id, List.of(_drafts));
    setState(() {
      _drafts.clear();
      _composing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tugas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
                if (!_composing)
                  Text(
                    _tugas.status.label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            for (final item in _tugas.lampiran) ...[
              _buildAttachment(item),
              const SizedBox(height: 10),
            ],
            if (_composing)
              ..._buildComposeSection()
            else
              ..._buildViewSection(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildViewSection() {
    return [
      SizedBox(
        width: double.infinity,
        child: _softButton(
          Icons.add_box_outlined,
          'Tambah',
          () => setState(() => _composing = true),
        ),
      ),
      if (_tugas.status == TugasStatus.ditugaskan) ...[
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: _blueButton(
            'Tandai Sebagai Selesai',
            () => widget.controller.updateTugasStatus(
              _tugas.id,
              TugasStatus.ditandaiSelesai,
            ),
          ),
        ),
      ],
    ];
  }

  List<Widget> _buildComposeSection() {
    return [
      for (final draft in _drafts) ...[
        _buildAttachment(draft, onRemove: () => _removeDraft(draft)),
        const SizedBox(height: 10),
      ],
      Row(
        children: [
          Expanded(
            child: _softButton(Icons.description_outlined, 'File', _addFile),
          ),
          const SizedBox(width: 12),
          Expanded(child: _softButton(Icons.link, 'Link', _addLink)),
        ],
      ),
      if (_drafts.isNotEmpty) ...[
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: _blueButton('Serahkan', _submit),
        ),
      ],
    ];
  }

  Widget _buildAttachment(LampiranModel item, {VoidCallback? onRemove}) {
    final card = FileCard(
      fileName: item.name,
      fileType: item.detail,
      icon: item.type == LampiranType.link
          ? Icons.link
          : Icons.description_outlined,
    );

    if (onRemove == null) return card;

    return Row(
      children: [
        Expanded(child: card),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.close, color: AppColors.text),
        ),
      ],
    );
  }

  Widget _softButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: AppButtonStyles.softCompact,
    );
  }

  Widget _blueButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.color1,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
