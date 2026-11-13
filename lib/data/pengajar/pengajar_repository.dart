import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_mobile/data/api_helper.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/data/pengajar/pengumpulan_model.dart';
import 'package:path_mobile/data/pengajar/tugas_pengajar_model.dart';
import 'package:path_mobile/utils/http_client.dart';

class PengajarRepository extends ChangeNotifier {
  final HttpClient _client;
  final int? Function()? currentUserId;

  PengajarRepository(this._client, {this.currentUserId});

  final List<ClassModel> _teaching = [];
  List<ClassModel> get teachingClasses => List.unmodifiable(_teaching);

  final Map<String, List<MateriModel>> _materi = {};
  List<MateriModel> materiOf(ClassModel c) =>
      List.unmodifiable(_materi[c.code] ?? const []);

  final Map<String, List<TugasPengajarModel>> _tugas = {};
  List<TugasPengajarModel> tugasOf(ClassModel c) =>
      List.unmodifiable(_tugas[c.code] ?? const []);

  List<TugasPengajarModel> get allTugas =>
      _tugas.values.expand((e) => e).toList();

  TugasPengajarModel? tugasById(ClassModel c, String id) {
    for (final t in _tugas[c.code] ?? const <TugasPengajarModel>[]) {
      if (t.id == id) return t;
    }
    return null;
  }

  final Map<String, List<PengumpulanModel>> _pengumpulan = {};
  List<PengumpulanModel> pengumpulanOf(String tugasId) =>
      List.unmodifiable(_pengumpulan[tugasId] ?? const []);

  void clear() {
    _teaching.clear();
    _materi.clear();
    _tugas.clear();
    _pengumpulan.clear();
    notifyListeners();
  }

  /// Memuat daftar kelas yang diampu pengajar dari `GET /kelas` (`pengampu == myId`).
  Future<String?> fetchTeachingClasses() async {
    try {
      final response = await _client
          .get(_client.uri('/kelas'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return parseApiError(response, 'Gagal memuat kelas pengajar');
      }

      final decoded = jsonDecode(response.body);
      final data = decoded is List ? decoded : const [];
      final myId = currentUserId?.call();

      _teaching.clear();
      var index = 0;
      for (final item in data) {
        if (item is! Map<String, dynamic>) continue;
        final km = KelasModel.fromJson(item);
        if (myId != null && km.pembuat == myId) {
          _teaching.add(km.toClassModel(index: index++));
        }
      }
      notifyListeners();
      return null;
    } catch (e) {
      return 'Gagal memuat kelas pengajar: $e';
    }
  }

  /// Membuat kelas baru lewat `POST /kelas`.
  Future<String?> createClass({
    required String title,
    required String grade,
  }) async {
    final tingkat = KelasModel.parseTingkat(grade);
    try {
      final res = await _client
          .post(
            _client.uri('/kelas'),
            body: jsonEncode({
              'nama': title,
              'tingkat': tingkat,
              'tahun_ajaran': '2026/2027',
            }),
            headers: _client.json,
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200 && res.statusCode != 201) {
        return parseApiError(res, 'Gagal membuat kelas');
      }
      await fetchTeachingClasses();
      return null;
    } catch (e) {
      return 'Gagal membuat kelas: $e';
    }
  }

  /// Memuat materi (`tipe=1`) dan tugas (`tipe=2`) untuk kelas `c`.
  Future<void> fetchClassContent(ClassModel c) async {
    final code = c.code;
    if (code == null || code.isEmpty) return;

    try {
      final results = await Future.wait([
        _client.get(_client.uri('/kelas/$code/posts?tipe=1')),
        _client.get(_client.uri('/kelas/$code/posts?tipe=2')),
      ]);

      final materiRes = results[0];
      final tugasRes = results[1];

      if (materiRes.statusCode == 200) {
        final decoded = jsonDecode(materiRes.body);
        final rawMateri = decoded is List ? decoded : const [];
        _materi[code] = rawMateri
            .whereType<Map<String, dynamic>>()
            .map((e) => MateriModel.fromJson(e))
            .toList();
      }

      if (tugasRes.statusCode == 200) {
        final decoded = jsonDecode(tugasRes.body);
        final rawTugas = decoded is List ? decoded : const [];
        _tugas[code] = rawTugas
            .whereType<Map<String, dynamic>>()
            .map((e) => TugasPengajarModel.fromJson(e))
            .toList();
      }

      notifyListeners();
    } catch (_) {}
  }

  Future<String?> addMateri(ClassModel c, MateriModel m) async {
    final code = c.code;
    if (code == null || code.isEmpty) return 'Kode kelas tidak ditemukan';

    try {
      final lampiranPaths = await uploadPostinganFiles(_client, m.lampiran);
      final res = await _client
          .post(
            _client.uri('/kelas/$code/posts'),
            body: jsonEncode({
              'judul': m.title,
              'deskripsi': m.description,
              'lampiran': lampiranPaths,
              'tipe': 1,
            }),
            headers: _client.json,
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200 && res.statusCode != 201) {
        return parseApiError(res, 'Gagal menambahkan materi');
      }

      final created = jsonDecode(res.body);
      if (created is Map<String, dynamic>) {
        _materi.putIfAbsent(code, () => []).insert(0, MateriModel.fromJson(created));
        notifyListeners();
      }
      return null;
    } catch (e) {
      return 'Gagal menambahkan materi: $e';
    }
  }

  Future<String?> updateMateri(
    ClassModel c,
    MateriModel old, {
    required String title,
    required String description,
  }) async {
    final code = c.code;
    if (code == null || code.isEmpty || old.id == null) {
      return 'Materi tidak bisa diperbarui';
    }

    try {
      final lampiranPaths = await uploadPostinganFiles(_client, old.lampiran);
      final res = await _client
          .patch(
            _client.uri('/kelas/$code/postingan/${old.id}'),
            body: jsonEncode({
              'judul': title,
              'deskripsi': description,
              'lampiran': lampiranPaths,
              'tipe': 1,
            }),
            headers: _client.json,
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) {
        return parseApiError(res, 'Gagal memperbarui materi');
      }

      final updatedJson = jsonDecode(res.body);
      final list = _materi[code];
      final i = list?.indexWhere((m) => m.id == old.id) ?? -1;
      if (i != -1 && updatedJson is Map<String, dynamic>) {
        list![i] = MateriModel.fromJson(updatedJson);
        notifyListeners();
      }
      return null;
    } catch (e) {
      return 'Gagal memperbarui materi: $e';
    }
  }

  Future<String?> addTugas(ClassModel c, TugasPengajarModel t) async {
    final code = c.code;
    if (code == null || code.isEmpty) return t.id;

    try {
      final lampiranPaths = await uploadPostinganFiles(_client, t.lampiran);
      final res = await _client
          .post(
            _client.uri('/kelas/$code/posts'),
            body: jsonEncode({
              'judul': t.title,
              'deskripsi': t.description,
              'lampiran': lampiranPaths,
              'tipe': 2,
            }),
            headers: _client.json,
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final created = jsonDecode(res.body);
        if (created is Map<String, dynamic>) {
          final model = TugasPengajarModel.fromJson(created);
          _tugas.putIfAbsent(code, () => []).insert(0, model);
          notifyListeners();
          return model.id;
        }
      }
    } catch (_) {}
    return null;
  }

  Future<String?> updateTugas(ClassModel c, TugasPengajarModel updated) async {
    final code = c.code;
    if (code == null || code.isEmpty) return 'Kode kelas tidak ditemukan';

    try {
      final lampiranPaths = await uploadPostinganFiles(
        _client,
        updated.lampiran,
      );
      final res = await _client
          .patch(
            _client.uri('/kelas/$code/postingan/${updated.id}'),
            body: jsonEncode({
              'judul': updated.title,
              'deskripsi': updated.description,
              'lampiran': lampiranPaths,
              'tipe': 2,
            }),
            headers: _client.json,
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) {
        return parseApiError(res, 'Gagal memperbarui tugas');
      }

      final updatedJson = jsonDecode(res.body);
      final list = _tugas[code];
      final i = list?.indexWhere((t) => t.id == updated.id) ?? -1;
      if (i != -1 && updatedJson is Map<String, dynamic>) {
        list![i] = TugasPengajarModel.fromJson(updatedJson).withEdits(
          title: updated.title,
          description: updated.description,
          dueDate: updated.dueDate,
          acceptSubmissions: updated.acceptSubmissions,
          lampiran: list[i].lampiran,
        );
        notifyListeners();
      }
      return null;
    } catch (e) {
      return 'Gagal memperbarui tugas: $e';
    }
  }

  void saveScores(String tugasId, Map<String, int> scores) {
    final list = _pengumpulan[tugasId];
    if (list == null) return;
    for (var i = 0; i < list.length; i++) {
      final score = scores[list[i].studentName];
      if (score == null) continue;
      list[i] = list[i].copyWith(
        score: score,
        status: PengumpulanStatus.dinilai,
      );
    }
    notifyListeners();
  }

  void setAcceptSubmissions(ClassModel c, String id, bool value) {
    final t = tugasById(c, id);
    if (t == null) return;
    updateTugas(
      c,
      t.withEdits(
        title: t.title,
        description: t.description,
        dueDate: t.dueDate,
        acceptSubmissions: value,
        lampiran: t.lampiran,
      ),
    );
  }

  Future<MateriModel> generateAiMateri({
    required String title,
    required String prompt,
    String? mode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MateriModel(
      title: title,
      author: 'Pengajar',
      postedAt: DateTime.now(),
      description:
          'Materi dari permintaan: "$prompt"\n'
          'Pendukung: ${mode ?? 'standar'}',
      lampiran: const [],
    );
  }

  Future<Map<String, int>> generateAiKoreksi(
    List<PengumpulanModel> students,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return {
      for (final s in students) s.studentName: s.fileName == null ? 0 : 90,
    };
  }
}
