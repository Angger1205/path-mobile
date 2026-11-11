import 'dart:async';
import 'dart:convert';

import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/utils/http_client.dart';

class KelasRepository {
  final HttpClient _client;

  KelasRepository(this._client);

  Future<(List<KelasModel>?, String?)> getListKelas() async {
    try {
      final response = await _client
          .get(_client.uri('/kelas'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (null, data['message'] as String? ?? 'Gagal memuat kelas');
      }

      final data = jsonDecode(response.body) as List<dynamic>;
      final kelasList = data
          .map((x) => KelasModel.fromJson(x as Map<String, dynamic>))
          .toList();

      return (kelasList, null);
    } on TimeoutException {
      return (null, 'Request timed out. Please try again.');
    } catch (e) {
      return (null, 'Network error: $e');
    }
  }

  Future<(KelasModel?, String?)> getKelas(int kelasID) async {
    try {
      final response = await _client
          .get(_client.uri('/kelas/$kelasID'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (null, data['message'] as String? ?? 'Gagal memuat kelas');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final kelas = KelasModel.fromJson(data);

      return (kelas, null);
    } on TimeoutException {
      return (null, 'Request timed out. Please try again.');
    } catch (e) {
      return (null, 'Network error: $e');
    }
  }
}
