import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_routes.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/pengajar/buat_materi_screen.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/widgets/lampiran_card.dart';

class KonfirmasiMateriAiScreen extends StatelessWidget {
  final PengajarController controller;
  final ClassModel classData;
  final MateriModel materi;

  const KonfirmasiMateriAiScreen({
    super.key,
    required this.controller,
    required this.classData,
    required this.materi,
  });

  void _use(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    controller.addMateri(classData, materi);
    Navigator.of(context).popUntil(
      ModalRoute.withName(AppRoutes.pengajarDetail),
    );

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Materi berhasil dibuat')));
  }

  void _adjust(BuildContext context) {
    replacePage(
      context,
      breadcrumb: ['Pengajar', classData.title, 'Buat Materi'],
      page: BuatMateriScreen(
        controller: controller,
        classData: classData,
        initialTitle: materi.title,
        initialDescription: materi.description,
        initialLampiran: materi.lampiran,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BackTitleRow(title: materi.title),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  materi.description,
                  style: const TextStyle(fontSize: 12, color: AppColors.text),
                ),
                const SizedBox(height: 16),
                for (final item in materi.lampiran) ...[
                  LampiranCard(data: item),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 4),
                const Text(
                  'Apakah anda ingin menggunakan materi ini ?',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => _use(context),
                      style: FilledButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: const Text('Gunakan materi'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: AppButtonStyles.softCompact,
                      onPressed: () => _adjust(context),
                      child: const Text('Sesuaikan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
