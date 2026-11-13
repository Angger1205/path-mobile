import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/pengajar/konfirmasi_materi_ai_screen.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';

class BuatMateriAiScreen extends StatefulWidget {
  final PengajarController controller;
  final ClassModel classData;

  const BuatMateriAiScreen({
    super.key,
    required this.controller,
    required this.classData,
  });

  @override
  State<BuatMateriAiScreen> createState() => _BuatMateriAiScreenState();
}

class _BuatMateriAiScreenState extends State<BuatMateriAiScreen> {
  static const _baseModes = ['Tabel', 'Diagram', 'Ilustrasi'];
  static const _modes = ['Tabel', 'Diagram', 'Ilustrasi', 'Kombinasi'];

  final _titleController = TextEditingController();
  final _promptController = TextEditingController();
  final Set<String> _selectedModes = {};
  bool _isLoading = false;

  bool get _canCreate =>
      _titleController.text.trim().isNotEmpty &&
      _promptController.text.trim().isNotEmpty &&
      !_isLoading;

  @override
  void dispose() {
    _titleController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  void _toggleMode(String label) {
    setState(() {
      if (label == 'Kombinasi') {
        if (_selectedModes.contains('Kombinasi')) {
          _selectedModes.clear();
        } else {
          _selectedModes.addAll(_modes);
        }
      } else {
        if (_selectedModes.contains(label)) {
          _selectedModes.remove(label);
          _selectedModes.remove('Kombinasi');
        } else {
          _selectedModes.add(label);
          if (_baseModes.every(_selectedModes.contains)) {
            _selectedModes.add('Kombinasi');
          }
        }
      }
    });
  }

  Future<void> _generate() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    final activeModes = _selectedModes
        .where((m) => m != 'Kombinasi')
        .toList();
    final modeText = activeModes.isEmpty ? null : activeModes.join(', ');

    final result = await widget.controller.generateAiMateri(
      title: _titleController.text.trim(),
      prompt: _promptController.text.trim(),
      mode: modeText,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    openPage(
      context,
      breadcrumb: ['Pengajar', widget.classData.title, 'Buat Materi'],
      page: KonfirmasiMateriAiScreen(
        controller: widget.controller,
        classData: widget.classData,
        materi: result,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BackTitleRow(title: 'Buat materi dengan AI'),
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
                if (_titleController.text.trim().isEmpty) _requiredHint(),
                const SizedBox(height: 12),
                TextField(
                  controller: _promptController,
                  onChanged: (_) => setState(() {}),
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 12, color: AppColors.text),
                  decoration: _underline(
                    'Apa materi yang ingin anda buat?',
                    12,
                  ),
                ),
                if (_promptController.text.trim().isEmpty) _requiredHint(),
                const SizedBox(height: 16),
                const Text(
                  'Tambahkan elemen pendukung',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _modes.map(_buildChip).toList(),
                ),
                const SizedBox(height: 20),
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
                        'Menyiapkan materi...',
                        style: TextStyle(fontSize: 11, color: AppColors.text),
                      ),
                    ],
                  )
                else
                  FilledButton(
                    onPressed: _canCreate ? _generate : null,
                    style: FilledButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                    ),
                    child: const Text('Buat materi'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _requiredHint() {
    return const Padding(
      padding: EdgeInsets.only(top: 4),
      child: Text(
        'Isian wajib diisi',
        style: TextStyle(fontSize: 10, color: AppColors.secondaryText),
      ),
    );
  }

  Widget _buildChip(String label) {
    final selected = _selectedModes.contains(label);

    return ElevatedButton(
      onPressed: () => _toggleMode(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? AppColors.color1 : AppColors.card,
        foregroundColor: selected ? Colors.white : AppColors.text,
        elevation: 3,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(0, 32),
        textStyle: const TextStyle(fontSize: 11),
      ),
      child: Text(label),
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
