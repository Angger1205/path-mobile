import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.card,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.text,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Lupa Password',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SizedBox(
                height: constraints.maxHeight,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 24,
                          color: AppColors.text,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lupa Password ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Jangan khawatir. Masukkan alamat email yang '
                          'terdaftar di akun Anda, dan kami akan mengirimkan '
                          'tautan untuk mengatur ulang kata sandi Anda.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Alamat Email',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.text,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan alamat email',
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              final email = _emailController.text.trim();

                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Masukkan alamat email terlebih dahulu.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Fitur reset password belum terhubung '
                                    'ke backend.',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.color1,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Kirim Tautan Reset',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
