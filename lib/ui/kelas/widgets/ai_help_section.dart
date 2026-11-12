import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';

class AiHelpSection extends StatefulWidget {
  final KelasController controller;

  const AiHelpSection({super.key, required this.controller});

  @override
  State<AiHelpSection> createState() => _AiHelpSectionState();
}

class _AiHelpSectionState extends State<AiHelpSection> {
  static const _modes = ['Tabel', 'Diagram', 'Ilustrasi', 'Kombinasi'];
  static const _labelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  final _textController = TextEditingController();
  String? _selectedMode;
  String? _question;
  String? _answer;
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final question = _textController.text.trim();
    if (question.isEmpty || _isLoading) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _question = question;
      _answer = null;
      _isLoading = true;
    });

    final answer = await widget.controller.askAi(question, _selectedMode);

    if (!mounted) return;
    setState(() {
      _answer = answer;
      _isLoading = false;
    });
  }

  void _askAgain() {
    setState(() {
      _question = null;
      _answer = null;
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.secondaryText.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 20),
        const Text(
          'Bantuan AI',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Apakah anda kebingungan?\nPilih bantuan yang diinginkan',
          style: _labelStyle,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _modes.map(_buildChip).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Atau tanyakan melalui chat', style: _labelStyle),
        const SizedBox(height: 8),
        _buildChatArea(),
      ],
    );
  }

  Widget _buildChip(String label) {
    final selected = _selectedMode == label;

    return ElevatedButton(
      onPressed: () => setState(() => _selectedMode = selected ? null : label),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? AppColors.color1 : AppColors.card,
        foregroundColor: selected ? Colors.white : AppColors.text,
        elevation: 3,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        minimumSize: const Size(0, 34),
        textStyle: const TextStyle(fontSize: 11),
      ),
      child: Text(label),
    );
  }

  Widget _buildChatArea() {
    if (_question == null) return _buildInput();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.color1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _question!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
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
                'Menyiapkan jawaban...',
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
            ],
          )
        else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.secondaryText.withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              _answer ?? '',
              style: const TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: _askAgain, child: const Text('Tanya lagi')),
        ],
      ],
    );
  }

  Widget _buildInput() {
    final canSend = _textController.text.trim().isNotEmpty;

    return Material(
      elevation: 3,
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        controller: _textController,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _send(),
        textInputAction: TextInputAction.send,
        style: const TextStyle(fontSize: 12, color: AppColors.text),
        decoration: InputDecoration(
          hintText: 'Tanyakan sesuatu dari materi',
          hintStyle: const TextStyle(
            fontSize: 12,
            color: AppColors.secondaryText,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.secondaryText.withValues(alpha: 0.25),
            ),
          ),
          suffixIcon: IconButton(
            onPressed: canSend ? _send : null,
            icon: Icon(
              Icons.send_outlined,
              color: canSend ? AppColors.color1 : AppColors.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}
