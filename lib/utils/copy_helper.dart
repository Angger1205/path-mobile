import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Menyalin teks ke clipboard lalu menampilkan notifikasi kecil di bawah.
Future<void> copyWithNotice(
  BuildContext context, {
  required String text,
  required String message,
}) async {
  await Clipboard.setData(ClipboardData(text: text));
  // Setelah "await", cek dulu halamannya masih hidup
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
