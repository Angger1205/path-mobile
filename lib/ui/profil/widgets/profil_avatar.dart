import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class ProfilAvatar extends StatelessWidget {
  final Uint8List? photo;
  final double radius;

  const ProfilAvatar({super.key, this.photo, this.radius = 22});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.color1,
      backgroundImage: photo == null ? null : MemoryImage(photo!),
      child: photo == null
          ? Icon(Icons.person_outline, color: Colors.white, size: radius)
          : null,
    );
  }
}
