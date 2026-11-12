import 'package:flutter/material.dart';

/// Ikon dari gambar PNG. Kalau gambarnya gagal dimuat,
/// otomatis memakai ikon bawaan Flutter sebagai cadangan.
class PngIcon extends StatelessWidget {
  final String path;
  final double size;
  final IconData fallback;

  const PngIcon(
    this.path, {
    super.key,
    this.size = 20,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      errorBuilder: (_, _, _) => Icon(fallback, size: size),
    );
  }
}
