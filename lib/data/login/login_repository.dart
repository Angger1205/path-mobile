import 'dart:async';
import 'dart:convert';

import 'package:path_mobile/utils/http_client.dart';

class LoginRepository {
  final HttpClient _client;

  LoginRepository(this._client);

  /// Returns an error message on failure, or `null` on success.
  Future<String?> login(String email, String password) async {
    final body = {'email': email, 'password': password};

    try {
      final response = await _client
          .post(
            _client.uri('/login'),
            body: jsonEncode(body),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return _client.extractError(response, 'Gagal masuk');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token == null || token.isEmpty) {
        return 'Token tidak ditemukan';
      }
      _client.setToken(token);
      return null;
    } on TimeoutException {
      return 'Koneksi ke server habis waktu. Pastikan backend sedang berjalan.';
    } catch (e) {
      return 'Tidak dapat terhubung ke server: $e';
    }
  }
}
