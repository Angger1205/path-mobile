import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/register/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  final RegisterController controller;

  const RegisterScreen({super.key, required this.controller});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final ok = await widget.controller.register();
    if (ok && mounted) {
      context.go('/beranda');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 176),

                // Panel Register
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      border: Border.all(
                        color: AppColors.secondaryText.withValues(alpha: 0.6),
                        width: 0.8,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(48),
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 12),
                      ],
                    ),
                    child: ListenableBuilder(
                      listenable: ctrl,
                      builder: (context, _) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(44, 72, 44, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Judul halaman
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => context.go('/'),
                                    icon: const Icon(
                                      Icons.chevron_left,
                                      size: 24,
                                      color: AppColors.text,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 40,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Expanded(
                                    child: Text(
                                      'New Account',
                                      style: TextStyle(
                                        color: AppColors.text,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const CircleAvatar(
                                    radius: 19,
                                    backgroundColor: AppColors.color1,
                                    child: Icon(
                                      Icons.person_outline,
                                      color: Colors.white,
                                      size: 21,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 36),

                              const Text(
                                'Username',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _RegisterInput(
                                controller: ctrl.usernameController,
                                enabled: !ctrl.isLoading,
                                hintText: 'Joko Sutoyo',
                              ),

                              const SizedBox(height: 22),

                              const Text(
                                'Email',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _RegisterInput(
                                controller: ctrl.emailController,
                                enabled: !ctrl.isLoading,
                                hintText: 'contoh@email.com',
                                keyboardType: TextInputType.emailAddress,
                              ),

                              const SizedBox(height: 22),

                              const Text(
                                'Password',
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _RegisterInput(
                                controller: ctrl.passwordController,
                                enabled: !ctrl.isLoading,
                                hintText: 'Minimal 8 karakter',
                                obscureText: true,
                              ),

                              if (ctrl.errorMessage != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  ctrl.errorMessage!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 32),

                              SizedBox(
                                width: double.infinity,
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: ctrl.isLoading
                                      ? null
                                      : _handleRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.color1,
                                    foregroundColor: Colors.white,
                                    elevation: 3,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: ctrl.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Sign up',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              Center(
                                child: TextButton(
                                  onPressed: () => context.go('/login'),
                                  child: const Text(
                                    'Sudah punya akun? Sign in',
                                    style: TextStyle(
                                      color: AppColors.color1,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool enabled;
  final TextInputType keyboardType;

  const _RegisterInput({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.text, fontSize: 12),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.secondaryText.withValues(alpha: 0.7),
          fontSize: 12,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.only(top: 6, bottom: 10),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.secondaryText.withValues(alpha: 0.6),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.color1),
        ),
      ),
    );
  }
}
