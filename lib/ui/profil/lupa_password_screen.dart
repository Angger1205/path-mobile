import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/profil/profil_controller.dart';

class LupaPasswordScreen extends StatefulWidget {
  final ProfilController controller;

  const LupaPasswordScreen({super.key, required this.controller});

  @override
  State<LupaPasswordScreen> createState() => _LupaPasswordScreenState();
}

class _LupaPasswordScreenState extends State<LupaPasswordScreen> {
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  bool _submitting = false;

  bool get _canSend =>
      _oldController.text.length >= 8 &&
      _newController.text.length >= 8 &&
      !_submitting;

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    final err = await widget.controller.resetPassword(
      oldPassword: _oldController.text,
      newPassword: _newController.text,
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (err == null) Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(err ?? 'Kata sandi diperbarui')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BackTitleRow(title: 'Ganti Password'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.lock_open_outlined,
                    size: 28,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Ganti Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Masukkan kata sandi lama dan kata sandi baru minimal 8 karakter.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.secondaryText,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Password Lama',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _oldController,
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 13, color: AppColors.text),
                  decoration: InputDecoration(
                    hintText: 'Masukkan password lama',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Password Baru',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _newController,
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 13, color: AppColors.text),
                  decoration: InputDecoration(
                    hintText: 'Minimal 8 karakter',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _canSend ? _submit : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: Text(_submitting ? 'Menyimpan...' : 'Simpan Password'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
