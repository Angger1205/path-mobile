import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/pengajar/pengumpulan_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/pengajar/koreksi_ai_screen.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';

class _ScoreFormatter extends TextInputFormatter {
  final int max;
  _ScoreFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    if (text.length > 1 && text.startsWith('0')) return oldValue;
    final n = int.tryParse(text);
    if (n == null || n > max) return oldValue;
    return newValue;
  }
}

class CekJawabanScreen extends StatefulWidget {
  final PengajarController controller;
  final ClassModel classData;
  final String tugasId;

  const CekJawabanScreen({
    super.key,
    required this.controller,
    required this.classData,
    required this.tugasId,
  });

  @override
  State<CekJawabanScreen> createState() => _CekJawabanScreenState();
}

class _CekJawabanScreenState extends State<CekJawabanScreen> {
  static const _filters = ['Semua', 'Diserahkan', 'Ditugaskan', 'Dinilai'];

  PengajarController get _ctrl => widget.controller;

  final Map<String, TextEditingController> _controllers = {};
  String _filter = 'Semua';
  final Map<String, int?> _lastScores = {};

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_syncScores);
    _ctrl.fetchPengumpulan(widget.classData, widget.tugasId);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_syncScores);
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncScores() {
    for (final p in _ctrl.pengumpulanOf(widget.tugasId)) {
      final c = _controllers[p.studentName];
      if (c == null) continue;
      if (_lastScores[p.studentName] != p.score) {
        _lastScores[p.studentName] = p.score;
        c.text = p.score?.toString() ?? '';
      }
    }
  }

  TextEditingController _controllerFor(PengumpulanModel p) {
    return _controllers.putIfAbsent(p.studentName, () {
      _lastScores[p.studentName] = p.score;
      return TextEditingController(text: p.score?.toString() ?? '');
    });
  }

  void _save() {
    FocusScope.of(context).unfocus();

    final scores = <String, int>{};
    for (final p in _ctrl.pengumpulanOf(widget.tugasId)) {
      final n = int.tryParse(_controllers[p.studentName]?.text.trim() ?? '');
      if (n != null) scores[p.studentName] = n;
    }

    final message = scores.isEmpty
        ? 'Belum ada nilai yang diisi'
        : 'Nilai berhasil disimpan';
    if (scores.isNotEmpty) _ctrl.saveScores(widget.tugasId, scores);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _ctrl,
      builder: (context, _) {
        final tugas = _ctrl.tugasById(widget.classData, widget.tugasId);

        if (tugas == null) {
          return const Column(
            children: [
              BackTitleRow(title: 'Tugas'),
              Expanded(child: Center(child: Text('Tugas tidak ditemukan'))),
            ],
          );
        }

        final all = _ctrl.pengumpulanOf(widget.tugasId);

        return Column(
          children: [
            BackTitleRow(title: tugas.title),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  _buildSummary(all),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Switch(
                        value: tugas.acceptSubmissions,
                        onChanged: (v) => _ctrl.setAcceptSubmissions(
                          widget.classData,
                          widget.tugasId,
                          v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Menerima kiriman',
                        style: TextStyle(fontSize: 11, color: AppColors.text),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      onPressed: () => openPage(
                        context,
                        breadcrumb: [
                          'Pengajar',
                          widget.classData.title,
                          tugas.title,
                        ],
                        page: KoreksiAiScreen(
                          controller: _ctrl,
                          classData: widget.classData,
                          tugasId: widget.tugasId,
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
                            'Koreksi menggunakan AI',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.chevron_right, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterRow(),
                  const SizedBox(height: 12),
                  for (final status in PengumpulanStatus.values)
                    ..._buildGroup(
                      status,
                      all.where((p) => p.status == status).toList(),
                      tugas.points,
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummary(List<PengumpulanModel> all) {
    int count(PengumpulanStatus s) => all.where((p) => p.status == s).length;

    Widget cell(PengumpulanStatus s) => Expanded(
      child: Column(
        children: [
          Text(
            '${count(s)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          Text(
            s.label,
            style: const TextStyle(fontSize: 11, color: AppColors.text),
          ),
        ],
      ),
    );

    return IntrinsicHeight(
      child: Row(
        children: [
          cell(PengumpulanStatus.diserahkan),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.secondaryText,
          ),
          cell(PengumpulanStatus.ditugaskan),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.secondaryText,
          ),
          cell(PengumpulanStatus.dinilai),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: _filter,
          isDense: true,
          style: const TextStyle(fontSize: 11, color: AppColors.text),
          items: [
            for (final f in _filters)
              DropdownMenuItem(value: f, child: Text(f)),
          ],
          onChanged: (v) => setState(() => _filter = v ?? 'Semua'),
        ),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  List<Widget> _buildGroup(
    PengumpulanStatus status,
    List<PengumpulanModel> rows,
    int maxScore,
  ) {
    final visible = _filter == 'Semua' || _filter == status.label;
    if (!visible || rows.isEmpty) return const [];

    return [
      Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12),
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      status.label,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  Text(
                    '${rows.length} Orang',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16, thickness: 1, color: AppColors.text),
              for (var i = 0; i < rows.length; i++) ...[
                _buildRow(rows[i], maxScore),
                if (i < rows.length - 1)
                  const Divider(height: 1, thickness: 1, color: Colors.black12),
              ],
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildRow(PengumpulanModel p, int maxScore) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.studentName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                if (p.fileName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      p.fileName!,
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.secondaryText,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: TextField(
              controller: _controllerFor(p),
              textAlign: TextAlign.right,
              keyboardType: TextInputType.number,
              inputFormatters: [_ScoreFormatter(maxScore)],
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
              decoration: const InputDecoration(
                hintText: '...',
                isDense: true,
                filled: false,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Text(
            '/$maxScore',
            style: const TextStyle(fontSize: 11, color: AppColors.text),
          ),
        ],
      ),
    );
  }
}
