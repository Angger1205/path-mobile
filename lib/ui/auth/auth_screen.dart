import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/path_logo.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.card,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: SizedBox(
                  width: double.infinity,
                  height: constraints.maxHeight,
                  child: Stack(
                    children: [
                      // Logo PATH
                      const Positioned(
                        left: 24,
                        top: 26,
                        child: PathLogo(
                          width: 104,
                          height: 120,
                        ),
                      ),

                      // Tombol Welcome
                      Positioned(
                        top: constraints.maxHeight * 0.6875,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 196,
                              height: 42,
                              child: ElevatedButton(
                                onPressed: () => context.go('/login'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.color1,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                  elevation: 3,
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 196,
                              height: 42,
                              child: OutlinedButton(
                                onPressed: () => context.go('/register'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.card,
                                  foregroundColor: AppColors.color1,
                                  padding: EdgeInsets.zero,
                                  side: BorderSide(
                                    color: AppColors.secondaryText.withValues(
                                      alpha: 0.4,
                                    ),
                                    width: 0.8,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
