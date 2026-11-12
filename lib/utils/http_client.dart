import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_mobile/data/kelas/lampiran_model.dart';

class HttpClient extends http.BaseClient {
  static String get defaultBaseUrl {
    const envUrl = String.fromEnvironment('API_URL');
    if (envUrl.isNotEmpty) return envUrl;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  final String baseUrl;
  final http.Client _inner;
  String? token;

  HttpClient({http.Client? client, this.token, String? baseUrl})
    : _inner = client ?? http.Client(),
      baseUrl = baseUrl ?? defaultBaseUrl;

  void setToken(String? token) {
    this.token = token;
  }

  Uri uri(String path) => Uri.parse('$baseUrl$path');

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (token != null && token!.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return _inner.send(request);
  }

  String extractError(http.Response response, String fallback) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final errors = decoded['errors'];
        if (errors is List && errors.isNotEmpty) {
          final first = errors.first;
          if (first is Map && first['message'] != null) {
            return '${first['field'] ?? ''}: ${first['message']}'.trim();
          }
        }
        final msg = decoded['message'];
        if (msg is String && msg.isNotEmpty) return msg;
      }
    } catch (_) {}
    return fallback;
  }

  /// Mengunggah file lokal ke `POST /files/postingan` dan mengembalikan daftar
  /// path server (`/uploads/...`) atau URL link untuk disimpan di `lampiran`.
  Future<List<String>> uploadAttachments(List<LampiranModel> items) async {
    final result = <String>[];
    final filesToUpload = <LampiranModel>[];

    for (final item in items) {
      if (item.type == LampiranType.link) {
        result.add(item.detail);
      } else if (item.serverPath != null && item.serverPath!.isNotEmpty) {
        result.add(item.serverPath!);
      } else if (item.bytes != null && item.bytes!.isNotEmpty) {
        filesToUpload.add(item);
      } else if (item.name.isNotEmpty) {
        result.add(item.name);
      }
    }

    if (filesToUpload.isNotEmpty) {
      try {
        final request = http.MultipartRequest('POST', uri('/files/postingan'));
        for (final f in filesToUpload) {
          request.files.add(
            http.MultipartFile.fromBytes('files', f.bytes!, filename: f.name),
          );
        }
        final streamed = await send(request);
        final response = await http.Response.fromStream(streamed);
        if (response.statusCode == 201 || response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final uploaded = data['files'] as List<dynamic>? ?? const [];
          for (final u in uploaded) {
            if (u is Map<String, dynamic> && u['path'] is String) {
              result.add(u['path'] as String);
            }
          }
        } else {
          for (final f in filesToUpload) {
            result.add(f.name);
          }
        }
      } catch (_) {
        for (final f in filesToUpload) {
          result.add(f.name);
        }
      }
    }

    return result;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
