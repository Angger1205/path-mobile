import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/pengajar/widgets/lampiran_card.dart';
import 'package:path_mobile/utils/date_format.dart';

class PengajarMateriDetailScreen extends StatelessWidget {
  final MateriModel materi;

  const PengajarMateriDetailScreen({super.key, required this.materi});

  @override
  Widget build(BuildContext context) {
    final meta =
        '${materi.author} • ${formatTanggal(materi.postedAt)} • ${formatJam(materi.postedAt)}';
    final lampiran = materi.semuaLampiran;

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
                  meta,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                  ),
                ),
                if (materi.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    materi.description,
                    style: const TextStyle(fontSize: 12, color: AppColors.text),
                  ),
                ],
                const SizedBox(height: 16),
                for (final item in lampiran) ...[
                  LampiranCard(data: item),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
