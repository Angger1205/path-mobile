import 'package:flutter/material.dart';
import 'package:path_mobile/data/pengajar/pengumpulan_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

/// Daftar siswa bercentang, dikelompokkan per status.
/// Centang dimiliki halaman induk, widget ini melapor lewat onChanged.
class PengumpulanChecklist extends StatefulWidget {
  final List<PengumpulanModel> students;
  final Set<String> selected; // nama siswa yang tercentang
  final ValueChanged<Set<String>> onChanged;
  final int maxScore;

  // Nilai yang ditampilkan menggantikan nilai asli (dipakai hasil AI)
  final Map<String, int> scores;

  const PengumpulanChecklist({
    super.key,
    required this.students,
    required this.selected,
    required this.onChanged,
    this.maxScore = 100,
    this.scores = const {},
  });

  @override
  State<PengumpulanChecklist> createState() => _PengumpulanChecklistState();
}

class _PengumpulanChecklistState extends State<PengumpulanChecklist> {
  static const _filters = ['Semua', 'Diserahkan', 'Ditugaskan', 'Dinilai'];

  String _filter = 'Semua';

  List<PengumpulanModel> get _visible => widget.students
      .where((p) => _filter == 'Semua' || p.status.label == _filter)
      .toList();

  bool _allSelected(List<PengumpulanModel> rows) =>
      rows.isNotEmpty &&
      rows.every((p) => widget.selected.contains(p.studentName));

  void _setMany(List<PengumpulanModel> rows, bool value) {
    final next = {...widget.selected};
    for (final p in rows) {
      if (value) {
        next.add(p.studentName);
      } else {
        next.remove(p.studentName);
      }
    }
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _box(_allSelected(visible), (v) => _setMany(visible, v)),
            const SizedBox(width: 8),
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
          ],
        ),
        const SizedBox(height: 12),
        for (final status in PengumpulanStatus.values)
          ..._buildGroup(
            status,
            visible.where((p) => p.status == status).toList(),
          ),
      ],
    );
  }

  List<Widget> _buildGroup(
    PengumpulanStatus status,
    List<PengumpulanModel> rows,
  ) {
    if (rows.isEmpty) return const [];

    return [
      Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 12),
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 14, 4),
          child: Column(
            children: [
              Row(
                children: [
                  _box(_allSelected(rows), (v) => _setMany(rows, v)),
                  const SizedBox(width: 8),
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
              const Divider(height: 14, thickness: 1, color: AppColors.text),
              for (var i = 0; i < rows.length; i++) ...[
                _buildRow(rows[i]),
                if (i < rows.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.secondaryText.withValues(alpha: 0.2),
                  ),
              ],
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildRow(PengumpulanModel p) {
    final score = widget.scores[p.studentName] ?? p.score;
    final scoreText = score?.toString() ?? '...';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _box(
            widget.selected.contains(p.studentName),
            (v) => _setMany([p], v),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              p.studentName,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
          Text(
            '$scoreText/${widget.maxScore}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _box(bool value, ValueChanged<bool> onChanged) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Checkbox(
        value: value,
        onChanged: (v) => onChanged(v ?? false),
        activeColor: AppColors.text,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
