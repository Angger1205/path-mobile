import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_mobile/data/api_helper.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/utils/http_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Membuka link di browser. Kalau gagal, tampil notifikasi kecil.
Future<void> openLink(BuildContext context, String raw) async {
  var text = raw.trim();
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
    _showSnack(context, 'Link tidak bisa dibuka');
  }
}

String? _mimeTypeFor(String name, String detail) {
  final ext = (name.contains('.') ? name.split('.').last : detail)
      .trim()
      .toLowerCase();
  return switch (ext) {
    'pdf' => 'application/pdf',
    'doc' => 'application/msword',
    'docx' =>
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'xls' => 'application/vnd.ms-excel',
    'xlsx' =>
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'ppt' => 'application/vnd.ms-powerpoint',
    'pptx' =>
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'png' => 'image/png',
    'jpg' || 'jpeg' => 'image/jpeg',
    'gif' => 'image/gif',
    'webp' => 'image/webp',
    'txt' || 'csv' => 'text/plain',
    'zip' => 'application/zip',
    'mp4' => 'video/mp4',
    'mp3' => 'audio/mpeg',
    _ => null,
  };
}

/// Membuka lampiran lewat browser (link) atau aplikasi eksternal sesuai tipe MIME.
Future<void> openAttachment(BuildContext context, LampiranModel item) async {
  if (item.type == LampiranType.link) {
    await openLink(context, item.detail);
    return;
  }

  final client = HttpClient();
  try {
    final serverPath = item.serverPath;
    if (kIsWeb) {
      if (serverPath != null && serverPath.isNotEmpty) {
        await openLink(
          context,
          client.uri(normalizeServerPath(serverPath)).toString(),
        );
      }
      return;
    }

    var bytes = item.bytes;
    if ((bytes == null || bytes.isEmpty) &&
        serverPath != null &&
        serverPath.isNotEmpty) {
      final res = await client.get(client.uri(normalizeServerPath(serverPath)));
      if (res.statusCode == 200) {
        bytes = res.bodyBytes;
      }
    }

    if (bytes == null || bytes.isEmpty) {
      if (context.mounted) _showSnack(context, 'File lampiran tidak tersedia');
      return;
    }

    final dir = await getTemporaryDirectory();
    final safeName = item.name.replaceAll(RegExp(r'[^\w\-. ]'), '_');
    final file = File('${dir.path}/$safeName');
    await file.writeAsBytes(bytes);

    final result = await OpenFilex.open(
      file.path,
      type: _mimeTypeFor(item.name, item.detail),
    );
    if (result.type != ResultType.done && context.mounted) {
      _showSnack(
        context,
        result.type == ResultType.noAppToOpen
            ? 'Tidak ada aplikasi untuk membuka file ${item.detail}'
            : 'Gagal membuka file: ${result.message}',
      );
    }
  } catch (e) {
    if (context.mounted) _showSnack(context, 'Gagal membuka file: $e');
  } finally {
    client.close();
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
