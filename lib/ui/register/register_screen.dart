import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/register/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  final RegisterController _controller;

  const RegisterScreen({super.key, required this._controller});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final res = await widget._controller.register();
    if (res && mounted) {
      context.go('/beranda');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(64)),
            border: const Border.symmetric(
              horizontal: BorderSide(color: AppColors.secondaryText, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: ListenableBuilder(
                listenable: widget._controller,
                builder: (context, _) {
                  final ctrl = widget._controller;

                  return Column(
                    spacing: 32,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const BackButton(color: AppColors.text),
                          const Expanded(
                            child: Text(
                              "New Account",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            child: const Icon(Icons.person),
                          ),
                        ],
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 20,
                          children: [
                            TextFormField(
                              controller: ctrl.usernameController,
                              enabled: !ctrl.isLoading,
                              decoration: const InputDecoration(
                                labelText: "Username",
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Username tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: ctrl.emailController,
                              enabled: !ctrl.isLoading,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: "Email",
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(value.trim())) {
                                  return 'Format email tidak valid';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: ctrl.passwordController,
                              enabled: !ctrl.isLoading,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                if (value.length < 8) {
                                  return 'Password terlalu singkat';
                                }
                                return null;
                              },
                            ),
                            if (ctrl.errorMessage != null)
                              Text(
                                ctrl.errorMessage!,
                                style: TextStyle(color: colorScheme.error),
                              ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: ctrl.isLoading ? null : _handleRegister,
                        child: ctrl.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : const Text('Register'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
