import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';

class LupaPasswordScreen extends StatefulWidget {
  const LupaPasswordScreen({super.key});

  @override
  State<LupaPasswordScreen> createState() => _LupaPasswordScreenState();
}

class _LupaPasswordScreenState extends State<LupaPasswordScreen> {
  final _emailController = TextEditingController();

  bool get _canSend => _emailController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Tautan reset kata sandi telah dikirim')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BackTitleRow(title: 'Lupa Password'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                const Icon(
                  Icons.lock_open_outlined,
                  size: 28,
                  color: AppColors.text,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lupa Password ?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Jangan khawatir. Masukkan alamat email yang terdaftar di '
                  'akun Anda, dan kami akan mengirimkan tautan untuk mengatur '
                  'ulang kata sandi Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Alamat Email',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 13, color: AppColors.text),
                  decoration: InputDecoration(
                    hintText: 'Masukkan email Anda',
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _canSend ? _sendResetLink : null,
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
                    child: const Text('Kirim Tautan Reset'),
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
