import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';
import 'package:path_mobile/ui/kelas/widgets/ai_help_section.dart';
import 'package:path_mobile/ui/pengajar/widgets/lampiran_card.dart';
import 'package:path_mobile/utils/date_format.dart';

class MateriDetailScreen extends StatefulWidget {
  final KelasController controller;
  final MateriModel materi;

  const MateriDetailScreen({
    super.key,
    required this.controller,
    required this.materi,
  });

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen> {
  bool _showAi = false;

  @override
  Widget build(BuildContext context) {
    final materi = widget.materi;
    final lampiran = materi.semuaLampiran;
    final meta =
        '${materi.author} • ${formatTanggal(materi.postedAt)} • ${formatJam(materi.postedAt)}';

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
                const SizedBox(height: 12),
                Text(
                  materi.description,
                  style: const TextStyle(fontSize: 12, color: AppColors.text),
                ),
                const SizedBox(height: 16),
                for (final item in lampiran) ...[
                  LampiranCard(data: item),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 6),
                if (_showAi)
                  AiHelpSection(controller: widget.controller)
                else
                  _buildAiButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAiButton() {
    return ElevatedButton(
      onPressed: () => setState(() => _showAi = true),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.color1,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.fromLTRB(22, 12, 14, 12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bantuan AI', style: TextStyle(fontSize: 12)),
          SizedBox(width: 8),
          Icon(Icons.chevron_right, size: 20),
        ],
      ),
    );
  }
}
