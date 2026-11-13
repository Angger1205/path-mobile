import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/ui/kelas/widgets/file_card.dart';
import 'package:path_mobile/utils/link_helper.dart';

/// Kartu satu lampiran. Ikon di kanan menyesuaikan jenisnya (file atau link).
/// Bisa ditekan untuk dibuka di browser atau aplikasi eksternal sesuai format file.
class LampiranCard extends StatelessWidget {
  final LampiranModel data;
  final VoidCallback? onTap;

  const LampiranCard({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLink = data.type == LampiranType.link;

    return FileCard(
      fileName: data.name,
      fileType: data.detail,
      icon: isLink ? Icons.link : Icons.description_outlined,
      onTap: onTap ?? () => openAttachment(context, data),
    );
  }
}
