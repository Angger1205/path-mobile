import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Membuka link di browser. Kalau gagal, tampil notifikasi kecil.
Future<void> openLink(BuildContext context, String raw) async {
  var text = raw.trim();
  // Pengguna sering mengetik tanpa "https://", jadi kita tambahkan
  if (!text.startsWith('http://') && !text.startsWith('https://')) {
    text = 'https://$text';
  }

  var ok = false;
  final uri = Uri.tryParse(text);
  if (uri != null) {
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
  }

  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Link tidak bisa dibuka')));
  }
}
