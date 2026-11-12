import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/confirm_dialog.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';

class JoinClassView extends StatefulWidget {
  final KelasController controller;
  final VoidCallback onCancel;
  final VoidCallback onJoined;

  const JoinClassView({
    super.key,
    required this.controller,
    required this.onCancel,
    required this.onJoined,
  });

  @override
  State<JoinClassView> createState() => _JoinClassViewState();
}

class _JoinClassViewState extends State<JoinClassView> {
  final _codeController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _codeController.text.trim();
    final isFormatOk = RegExp(r'^[a-zA-Z0-9]{5,8}$').hasMatch(code);
    if (!isFormatOk) {
      _showError();
      return;
    }

    setState(() => _submitting = true);
    final ok = await widget.controller.joinByCode(code);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (ok) {
      widget.onJoined();
    } else {
      _showError();
    }
  }

  void _showError() {
    showInfoDialog(
      context,
      title: 'Terjadi error',
      message:
          'Tidak dapat bergabung ke kelas ini. Periksa kode dan akun, lalu coba lagi.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Gabung ke kelas',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 3,
            color: AppColors.card,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kode Kelas',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mintalah kode kelas kepada pengajar, lalu masukkan kode di sini',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _codeController,
                    onChanged: (_) => setState(() {}),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9]'),
                      ),
                      LengthLimitingTextInputFormatter(8),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Kode Kelas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Untuk login menggunakan kode kelas',
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '1. Gunakan akun yang diberi otorisasi',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          Text(
            '2. Gunakan kode kelas yang terdiri dari 5-8 huruf atau angka, tanpa spasi atau simbol',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _submitting ? null : widget.onCancel,
                child: const Text('Batal'),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: _codeController.text.isNotEmpty && !_submitting
                    ? _submit
                    : null,
                child: const Text('Gabung Kelas'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
