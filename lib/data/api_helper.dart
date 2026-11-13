import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/utils/http_client.dart';

String parseApiError(http.Response response, String fallback) {
  try {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final errors = decoded['errors'];
      if (errors is List && errors.isNotEmpty && errors.first is Map) {
        final first = errors.first as Map;
        final msg = first['message'];
        if (msg != null) {
          final field = first['field']?.toString() ?? '';
          return field.isEmpty ? '$msg' : '$field: $msg';
        }
      }
      final msg = decoded['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }
  } catch (_) {}
  return fallback;
}

/// Memastikan path file relatif dari backend diawali '/' agar valid digabung dengan baseUrl.
String normalizeServerPath(String raw) {
  final path = raw.trim();
  if (path.isEmpty ||
      path.startsWith('/') ||
      path.startsWith('http://') ||
      path.startsWith('https://')) {
    return path;
  }
  return '/$path';
}

/// Mengubah format nomor lokal Indonesia (08...) menjadi format E.164 (+628...).
String toE164Phone(String raw) {
  final clean = raw.replaceAll(RegExp(r'[\s\-()]'), '');
  if (clean.startsWith('0')) return '+62${clean.substring(1)}';
  if (clean.startsWith('62')) return '+$clean';
  return clean;
}

/// Mengunggah lampiran file lokal ke `POST /files/postingan` dan mengembalikan
/// daftar path `/uploads/...` serta URL link siap kirim ke `/kelas/:kode/posts`.
Future<List<String>> uploadPostinganFiles(
  HttpClient client,
  List<LampiranModel> items,
) async {
  final result = <String>[];
  final toUpload = <LampiranModel>[];

  for (final item in items) {
    if (item.type == LampiranType.link) {
      result.add(item.detail);
    } else if (item.serverPath != null && item.serverPath!.isNotEmpty) {
      result.add(normalizeServerPath(item.serverPath!));
    } else if (item.bytes != null && item.bytes!.isNotEmpty) {
      toUpload.add(item);
    }
  }

  if (toUpload.isEmpty) return result;

  final req = http.MultipartRequest('POST', client.uri('/files/postingan'));
  for (final f in toUpload) {
    req.files.add(
      http.MultipartFile.fromBytes('files', f.bytes!, filename: f.name),
    );
  }

  final res = await http.Response.fromStream(
    await client.send(req).timeout(const Duration(seconds: 20)),
  );
  if (res.statusCode != 200 && res.statusCode != 201) {
    throw Exception(parseApiError(res, 'Gagal mengunggah file lampiran'));
  }

  final data = jsonDecode(res.body) as Map<String, dynamic>;
  final uploaded = data['files'] as List<dynamic>? ?? const [];
  for (final u in uploaded) {
    if (u is Map<String, dynamic> && u['path'] is String) {
      result.add(normalizeServerPath(u['path'] as String));
    }
  }
  return result;
}
