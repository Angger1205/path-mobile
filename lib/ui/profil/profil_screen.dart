import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/confirm_dialog.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/profil/edit_profil_screen.dart';
import 'package:path_mobile/ui/profil/lupa_password_screen.dart';
import 'package:path_mobile/ui/profil/profil_controller.dart';
import 'package:path_mobile/ui/profil/widgets/profil_avatar.dart';
import 'package:path_mobile/ui/profil/widgets/profil_header.dart';

class ProfilScreen extends StatelessWidget {
  final ProfilController controller;

  const ProfilScreen({super.key, required this.controller});

  static const _divider = Divider(
    height: 1,
    thickness: 1,
    color: Colors.black26,
  );

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      breadcrumb: const ['Profil'],
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Column(
            children: [
              ProfilHeader(onLogout: () => _handleLogout(context)),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          ProfilAvatar(photo: controller.photo),
                          const SizedBox(width: 12),
                          const Text(
                            'Foto profil',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _divider,
                    _InfoRow(
                      icon: Icons.manage_accounts_outlined,
                      label: 'Display name',
                      value: controller.name.isEmpty ? '-' : controller.name,
                    ),
                    _divider,
                    _InfoRow(
                      icon: Icons.mail_outline,
                      label: 'Email',
                      value: controller.email.isEmpty ? '-' : controller.email,
                    ),
                    _divider,
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: controller.phone.isEmpty ? '-' : controller.phone,
                    ),
                    _divider,
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        FilledButton(
                          onPressed: () => openPage(
                            context,
                            breadcrumb: ['Profil', 'Edit Profil'],
                            page: EditProfilScreen(controller: controller),
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          child: const Text('Edit profil'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => openPage(
                            context,
                            breadcrumb: ['Profil', 'Ganti Password'],
                            page: LupaPasswordScreen(controller: controller),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.card,
                            foregroundColor: AppColors.text,
                            elevation: 3,
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          child: const Text('Ganti password'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final yes = await showConfirmDialog(
      context,
      title: 'Keluar',
      message: 'Apakah Anda yakin ingin keluar dari akun?',
    );
    if (!yes || !context.mounted) return;

    controller.logout();
    context.go('/login');
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.text),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 13, color: AppColors.text),
          ),
        ],
      ),
    );
  }
}
