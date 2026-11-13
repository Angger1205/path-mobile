import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_mobile/data/api_helper.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/data/kelas/tugas_model.dart';
import 'package:path_mobile/utils/http_client.dart';

class KelasRepository extends ChangeNotifier {
  final HttpClient _client;
  final int? Function()? currentUserId;

  KelasRepository(this._client, {this.currentUserId});

  final Map<String, ClassModel> _joined = {};
  List<ClassModel> get joinedClasses => _joined.values.toList();

  final List<MateriModel> _materiList = [];
  List<MateriModel> get materiList => List.unmodifiable(_materiList);

  final List<TugasModel> _tugasItems = [];
  List<TugasModel> get tugasItems => List.unmodifiable(_tugasItems);

  void clear() {
    _joined.clear();
    _materiList.clear();
    _tugasItems.clear();
    notifyListeners();
  }

  /// Memuat kelas yang diikuti siswa dari `GET /kelas` (selain yang diampu sendiri).
  Future<String?> fetchJoinedClasses() async {
    try {
      final response = await _client
          .get(_client.uri('/kelas'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return parseApiError(response, 'Gagal memuat daftar kelas');
      }

      final decoded = jsonDecode(response.body);
      final data = decoded is List ? decoded : const [];
      final myId = currentUserId?.call();

      _joined.clear();
      var index = 0;
      for (final item in data) {
        if (item is! Map<String, dynamic>) continue;
        final km = KelasModel.fromJson(item);
        if (myId != null && km.pembuat == myId) continue;
        final cm = km.toClassModel(index: index++);
        if (cm.code != null && cm.code!.isNotEmpty) {
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

  /// Bergabung ke kelas lewat `POST /kelas/:kode_kelas/gabung`.
  Future<String?> joinByCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return 'Kode kelas tidak boleh kosong';

    try {
      final response = await _client
          .post(_client.uri('/kelas/$trimmed/gabung'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        return parseApiError(response, 'Gagal bergabung ke kelas');
      }

      await fetchJoinedClasses();
      return null;
    } catch (e) {
      return 'Tidak dapat bergabung ke kelas: $e';
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

  /// Memuat materi (`tipe=1`) dan tugas (`tipe=2`) dari backend.
  Future<void> fetchClassDetail(String kodeKelas) async {
    try {
      final results = await Future.wait([
        _client.get(_client.uri('/kelas/$kodeKelas/posts?tipe=1')),
        _client.get(_client.uri('/kelas/$kodeKelas/posts?tipe=2')),
      ]);

      final materiRes = results[0];
      final tugasRes = results[1];

      if (materiRes.statusCode == 200) {
        final decoded = jsonDecode(materiRes.body);
        final rawMateri = decoded is List ? decoded : const [];
        _materiList
          ..clear()
          ..addAll(
            rawMateri.whereType<Map<String, dynamic>>().map(
              (e) => MateriModel.fromJson(e),
            ),
          );
      }

      if (tugasRes.statusCode == 200) {
        final decoded = jsonDecode(tugasRes.body);
        final rawTugas = decoded is List ? decoded : const [];
        _tugasItems
          ..clear()
          ..addAll(
            rawTugas.whereType<Map<String, dynamic>>().map(
              (e) => TugasModel.fromJson(e),
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
  }

  Future<void> removeTugasAttachment(String id, int attachmentIndex) async {
    final index = _tugasItems.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final current = _tugasItems[index];
    if (attachmentIndex < 0 || attachmentIndex >= current.lampiran.length) {
      return;
    }

    final updatedList = List<LampiranModel>.from(current.lampiran)
      ..removeAt(attachmentIndex);

    _tugasItems[index] = current.copyWith(
      status: updatedList.isEmpty ? TugasStatus.ditugaskan : current.status,
      lampiran: updatedList,
    );
    notifyListeners();
  }

  Future<String> askAi(String question, String? mode) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final bentuk = mode ?? 'penjelasan ringkas';
    return 'Ringkasan AI ($bentuk) untuk pertanyaan:\n"$question"';
  }
}
