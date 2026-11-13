import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class PathLogo extends StatelessWidget {
  final double width;
  final double height;

  const PathLogo({super.key, this.width = 104, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_rounded,
            size: 52,
            color: AppColors.color1,
          ),
          SizedBox(height: 4),
          Text(
            'PATH',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.color1,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
    );
  }
}
