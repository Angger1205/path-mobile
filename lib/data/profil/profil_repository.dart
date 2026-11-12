import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_mobile/utils/http_client.dart';

class ProfilRepository extends ChangeNotifier {
  final HttpClient _client;

  ProfilRepository(this._client);

  HttpClient get client => _client;

  int? _id;
  String _name = '';
  String _email = '';
  String _phone = '';
  String? _profilePicturePath;
  Uint8List? _photo;

  int? get id => _id;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  Uint8List? get photo => _photo;

  Future<String?> fetchProfile() async {
    try {
      final response = await _client
          .get(_client.uri('/pengguna'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return _client.extractError(response, 'Gagal memuat profil');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _id = (data['id'] as num?)?.toInt();
      _name = data['nama'] as String? ?? '';
      _email = data['email'] as String? ?? '';
      _phone = data['phone'] as String? ?? '';
      final pic = data['profile_picture'] as String?;

      if (pic != null && pic.isNotEmpty && pic != _profilePicturePath) {
        _profilePicturePath = pic;
        try {
          final imgRes = await _client.get(_client.uri(pic));
          if (imgRes.statusCode == 200) {
            _photo = imgRes.bodyBytes;
          }
        } catch (_) {}
      }

      notifyListeners();
      return null;
    } catch (e) {
      return 'Gagal memuat profil: $e';
    }
  }

  Future<String?> update({required String name, Uint8List? photo}) async {
    final prevName = _name;
    final prevPhoto = _photo;
    _name = name;
    if (photo != null) _photo = photo;
    notifyListeners();

    try {
      if (name != prevName && name.isNotEmpty) {
        final res = await _client.patch(
          _client.uri('/pengguna/nama'),
          body: jsonEncode({'nama': name}),
          headers: {'Content-Type': 'application/json'},
        );
        if (res.statusCode != 200) {
          return _client.extractError(res, 'Gagal memperbarui nama');
        }
      }

      if (photo != null && !identical(photo, prevPhoto)) {
        final req = http.MultipartRequest(
          'PATCH',
          _client.uri('/pengguna/profile-picture'),
        );
        req.files.add(
          http.MultipartFile.fromBytes(
            'profile_picture',
            photo,
            filename: 'avatar.png',
          ),
        );
        final streamed = await _client.send(req);
        final res = await http.Response.fromStream(streamed);
        if (res.statusCode != 200) {
          return _client.extractError(res, 'Gagal memperbarui foto profil');
        }
      }

      return null;
    } catch (e) {
      return 'Gagal menyimpan profil: $e';
    }
  }

  Future<String?> updateEmail(String email) async {
    try {
      final res = await _client.patch(
        _client.uri('/pengguna/email'),
        body: jsonEncode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode != 200) {
        return _client.extractError(res, 'Gagal memperbarui email');
      }
      _email = email;
      notifyListeners();
      return null;
    } catch (e) {
      return 'Gagal memperbarui email: $e';
    }
  }

  Future<String?> updatePhone(String phone) async {
    try {
      final res = await _client.patch(
        _client.uri('/pengguna/phone'),
        body: jsonEncode({'phone': phone}),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode != 200) {
        return _client.extractError(res, 'Gagal memperbarui nomor telepon');
      }
      _phone = phone;
      notifyListeners();
      return null;
    } catch (e) {
      return 'Gagal memperbarui nomor telepon: $e';
    }
  }

  Future<String?> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final res = await _client.post(
        _client.uri('/pengguna/reset-password'),
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode != 200) {
        return _client.extractError(res, 'Gagal mengganti kata sandi');
      }
      return null;
    } catch (e) {
      return 'Gagal mengganti kata sandi: $e';
    }
  }
}
