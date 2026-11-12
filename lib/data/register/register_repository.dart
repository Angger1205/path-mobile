import 'dart:async';
import 'dart:convert';

import 'package:path_mobile/utils/http_client.dart';

class RegisterRepository {
  final HttpClient _client;

  RegisterRepository(this._client);

  Future<String?> register(String nama, String email, String password) async {
    final body = {'nama': nama, 'email': email, 'password': password};

    try {
      final response = await _client
          .post(
            _client.uri('/register'),
            body: jsonEncode(body),
            headers: _client.JSON,
          )
          .timeout(const Duration(seconds: 10));
      final data = jsonDecode(response.body);

      final token = data['token'] as String?;
      if (token == null || token.isEmpty) {
        return 'Failed to register. Please try again.';
      }
      _client.setToken(token);
      return null;
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }
}
