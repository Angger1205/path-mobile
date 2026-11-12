import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/profil/bantuan_screen.dart';

class ProfilHeader extends StatelessWidget {
  final bool showBack;

  const ProfilHeader({super.key, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(showBack ? 4 : 16, 8, 16, 8),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: AppColors.text),
            ),
          const Expanded(
            child: Text(
              'Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => openPage(
              context,
              breadcrumb: ['Profil', 'Bantuan'],
              page: const BantuanScreen(),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.card,
              foregroundColor: AppColors.text,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              minimumSize: const Size(0, 32),
              textStyle: const TextStyle(fontSize: 11),
            ),
            child: const Text('Bantuan'),
          ),
        ],
      ),
    );
  }
}
