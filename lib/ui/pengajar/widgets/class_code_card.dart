import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class ClassCodeCard extends StatelessWidget {
  final String code;
  final String className;
  final VoidCallback onCopyLink;
  final VoidCallback onCopyCode;
  final VoidCallback onReset;

  const ClassCodeCard({
    super.key,
    required this.code,
    required this.className,
    required this.onCopyLink,
    required this.onCopyCode,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 8, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Kode kelas',
                  style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                ),
                const SizedBox(width: 4),
                _buildMenu(),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  code,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _showBigCode(context),
                  child: const Icon(
                    Icons.open_in_full,
                    size: 16,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return SizedBox(
      width: 24,
      height: 24,
      child: PopupMenuButton<int>(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: const Icon(Icons.more_vert, color: AppColors.text),
        tooltip: 'Opsi kode kelas',
        color: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: (i) {
          switch (i) {
            case 0:
              onCopyLink();
            case 1:
              onCopyCode();
            case 2:
              onReset();
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(value: 0, child: Text('Salin link undangan kelas')),
          PopupMenuItem(value: 1, child: Text('Menyalin kode kelas')),
          PopupMenuItem(value: 2, child: Text('Reset kode kelas')),
        ],
      ),
    );
  }

  void _showBigCode(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kode kelas',
                    style: TextStyle(fontSize: 13, color: AppColors.text),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.text),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    code,
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                className,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
