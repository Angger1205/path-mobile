import 'dart:async';
import 'dart:convert';
import 'package:path_mobile/data/api_helper.dart';
import 'package:path_mobile/utils/http_client.dart';

class RegisterRepository {
  final HttpClient _client;

  RegisterRepository(this._client);

  /// Returns an error message on failure, or `null` on success.
  Future<String?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            _client.uri('/register'),
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
            }),
            headers: _client.json,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        return parseApiError(response, 'Gagal mendaftarkan akun');
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
