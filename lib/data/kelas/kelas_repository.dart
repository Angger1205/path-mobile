import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/data/kelas/tugas_model.dart';
import 'package:path_mobile/utils/http_client.dart';

class KelasRepository extends ChangeNotifier {
  final HttpClient _client;
  final List<ClassModel> Function()? extraClassesProvider;

  KelasRepository(this._client, {this.extraClassesProvider});

  // Kelas yang sudah diikuti: kode kelas -> data kelasnya
  final Map<String, ClassModel> _joined = {};

  List<ClassModel> get joinedClasses => _joined.values.toList();

  String? _activeClassCode;
  String? get activeClassCode => _activeClassCode;

  final List<MateriModel> _materiList = [];
  List<MateriModel> get materiList => List.unmodifiable(_materiList);

  final List<TugasModel> _tugasItems = [];
  List<TugasModel> get tugasItems => List.unmodifiable(_tugasItems);

  final List<String> _teachers = [];
  List<String> get teachers => List.unmodifiable(_teachers);

  final List<String> _students = [];
  List<String> get students => List.unmodifiable(_students);

  /// Memuat daftar kelas yang diikuti siswa dari `GET /kelas?role=siswa`.
  Future<String?> fetchJoinedClasses() async {
    try {
      final response = await _client
          .get(_client.uri('/kelas?role=siswa'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return _client.extractError(response, 'Gagal memuat daftar kelas');
      }

      final data = jsonDecode(response.body) as List<dynamic>? ?? const [];
      _joined.clear();
      for (var i = 0; i < data.length; i++) {
        final km = KelasModel.fromJson(data[i] as Map<String, dynamic>);
        final cm = km.toClassModel(index: i);
        if (cm.code != null) {
          _joined[cm.code!] = cm;
        }
      }
      notifyListeners();
      return null;
    } on TimeoutException {
      return 'Koneksi ke server habis waktu.';
    } catch (e) {
      return 'Gagal memuat kelas: $e';
    }
  }

  /// Mencoba bergabung ke kelas lewat `POST /kelas/:kode_kelas/gabung`.
  Future<bool> joinByCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return false;

    try {
      final response = await _client
          .post(_client.uri('/kelas/$trimmed/gabung'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }

      await fetchJoinedClasses();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Keluar dari kelas lewat `POST /kelas/:kode_kelas/keluar`.
  Future<void> leaveClass(ClassModel classModel) async {
    final code = classModel.code;
    _joined.removeWhere((_, value) => value.code == code || value == classModel);
    notifyListeners();

    if (code == null || code.isEmpty) return;
    try {
      await _client.post(_client.uri('/kelas/$code/keluar'));
    } catch (_) {}
  }

  /// Memuat materi, tugas, dan anggota kelas untuk `kodeKelas` dari backend.
  Future<void> fetchClassDetail(String kodeKelas) async {
    _activeClassCode = kodeKelas;
    try {
      final results = await Future.wait([
        _client.get(_client.uri('/kelas/$kodeKelas/posts?tipe=1')),
        _client.get(_client.uri('/kelas/$kodeKelas/posts?tipe=2')),
        _client.get(_client.uri('/kelas/$kodeKelas/anggota')),
      ]);

      final materiRes = results[0];
      final tugasRes = results[1];
      final anggotaRes = results[2];

      String teacherName = 'Pengajar';

      if (anggotaRes.statusCode == 200) {
        final rawAnggota =
            jsonDecode(anggotaRes.body) as List<dynamic>? ?? const [];
        _teachers.clear();
        _students.clear();
        for (final item in rawAnggota) {
          if (item is Map<String, dynamic>) {
            final nama = item['nama'] as String? ?? '';
            final isGuru = item['guru'] as bool? ?? false;
            if (nama.isEmpty) continue;
            if (isGuru) {
              _teachers.add(nama);
            } else {
              _students.add(nama);
            }
          }
        }
        if (_teachers.isNotEmpty) {
          teacherName = _teachers.first;
        }
      }

      if (materiRes.statusCode == 200) {
        final rawMateri =
            jsonDecode(materiRes.body) as List<dynamic>? ?? const [];
        _materiList
          ..clear()
          ..addAll(
            rawMateri.map(
              (e) => MateriModel.fromJson(
                e as Map<String, dynamic>,
                author: teacherName,
              ),
            ),
          );
      }

      if (tugasRes.statusCode == 200) {
        final rawTugas =
            jsonDecode(tugasRes.body) as List<dynamic>? ?? const [];
        _tugasItems
          ..clear()
          ..addAll(
            rawTugas.map(
              (e) => TugasModel.fromJson(
                e as Map<String, dynamic>,
                author: teacherName,
              ),
            ),
          );
      }

      notifyListeners();
    } catch (_) {}
  }

  TugasModel? tugasById(String id) {
    for (final tugas in _tugasItems) {
      if (tugas.id == id) return tugas;
    }
    return null;
  }

  void updateTugasStatus(String id, TugasStatus status) {
    final index = _tugasItems.indexWhere((t) => t.id == id);
    if (index == -1) return;

    _tugasItems[index] = _tugasItems[index].copyWith(status: status);
    notifyListeners();
  }

  Future<void> submitTugas(String id, List<LampiranModel> added) async {
    final index = _tugasItems.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final current = _tugasItems[index];
    final isLate = DateTime.now().isAfter(current.dueDate);

    _tugasItems[index] = current.copyWith(
      status: isLate ? TugasStatus.terlambat : TugasStatus.dikumpulkan,
      lampiran: [...current.lampiran, ...added],
    );
    notifyListeners();

    final kode = _activeClassCode;
    if (kode == null || kode.isEmpty) return;

    try {
      final lampiranPaths = await _client.uploadAttachments(added);
      await _client.post(
        _client.uri('/kelas/$kode/postingan/$id/kumpul'),
        body: jsonEncode({'lampiran': lampiranPaths}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (_) {}
  }

  Future<String> askAi(String question, String? mode) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final bentuk = mode ?? 'penjelasan ringkas';
    return 'Ringkasan AI ($bentuk) untuk pertanyaan:\n"$question"';
  }

  Future<(List<KelasModel>?, String?)> getListKelas() async {
    try {
      final response = await _client
          .get(_client.uri('/kelas'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return (
          null,
          _client.extractError(response, 'Gagal memuat daftar kelas'),
        );
      }

      final data = jsonDecode(response.body) as List<dynamic>? ?? const [];
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
        return (null, _client.extractError(response, 'Gagal memuat kelas'));
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
