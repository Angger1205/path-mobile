import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/data/pengajar/pengumpulan_model.dart';
import 'package:path_mobile/data/pengajar/tugas_pengajar_model.dart';
import 'package:path_mobile/ui/core/app_assets.dart';
import 'package:path_mobile/utils/http_client.dart';

class PengajarRepository extends ChangeNotifier {
  final HttpClient _client;

  PengajarRepository(this._client);

  HttpClient get client => _client;

  // Kelas yang dibuat pengajar
  final List<ClassModel> _teaching = [];

  List<ClassModel> get teachingClasses => List.unmodifiable(_teaching);

  // Materi per kelas: kode kelas -> daftar materinya
  final Map<String, List<MateriModel>> _materi = {};

  List<MateriModel> materiOf(ClassModel c) =>
      List.unmodifiable(_materi[c.code] ?? []);

  // Tugas per kelas: kode kelas -> daftar tugasnya
  final Map<String, List<TugasPengajarModel>> _tugas = {};

  List<TugasPengajarModel> tugasOf(ClassModel c) =>
      List.unmodifiable(_tugas[c.code] ?? []);

  List<TugasPengajarModel> get allTugas =>
      _tugas.values.expand((e) => e).toList();

  TugasPengajarModel? tugasById(ClassModel c, String id) {
    for (final t in _tugas[c.code] ?? const <TugasPengajarModel>[]) {
      if (t.id == id) return t;
    }
    return null;
  }

  // Pengumpulan per tugas: id tugas -> daftar siswanya
  final Map<String, List<PengumpulanModel>> _pengumpulan = {};

  List<PengumpulanModel> pengumpulanOf(String tugasId) =>
      List.unmodifiable(_pengumpulan[tugasId] ?? const []);

  // Anggota per kelas: kode kelas -> daftar nama
  final Map<String, List<String>> _teachers = {};
  final Map<String, List<String>> _students = {};

  List<String> _teacherList(ClassModel c) =>
      _teachers.putIfAbsent(c.code ?? '', () => []);

  List<String> _studentList(ClassModel c) =>
      _students.putIfAbsent(c.code ?? '', () => []);

  List<String> teachersOf(ClassModel c) => List.unmodifiable(_teacherList(c));
  List<String> studentsOf(ClassModel c) => List.unmodifiable(_studentList(c));

  /// Memuat daftar kelas yang diampu pengajar dari `GET /kelas?role=pengajar`.
  Future<String?> fetchTeachingClasses() async {
    try {
      final response = await _client
          .get(_client.uri('/kelas?role=pengajar'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return _client.extractError(response, 'Gagal memuat kelas pengajar');
      }

      final data = jsonDecode(response.body) as List<dynamic>? ?? const [];
      _teaching.clear();
      for (var i = 0; i < data.length; i++) {
        final km = KelasModel.fromJson(data[i] as Map<String, dynamic>);
        _teaching.add(km.toClassModel(index: i));
      }
      notifyListeners();
      return null;
    } catch (e) {
      return 'Gagal memuat kelas pengajar: $e';
    }
  }

  /// Memuat materi, tugas, dan anggota kelas untuk kelas `c` dari backend.
  Future<void> fetchClassContent(ClassModel c) async {
    final code = c.code;
    if (code == null || code.isEmpty) return;

    try {
      final results = await Future.wait([
        _client.get(_client.uri('/kelas/$code/posts?tipe=1')),
        _client.get(_client.uri('/kelas/$code/posts?tipe=2')),
        _client.get(_client.uri('/kelas/$code/anggota')),
      ]);

      final materiRes = results[0];
      final tugasRes = results[1];
      final anggotaRes = results[2];

      String teacherName = 'Pengajar';

      if (anggotaRes.statusCode == 200) {
        final rawAnggota =
            jsonDecode(anggotaRes.body) as List<dynamic>? ?? const [];
        final tList = <String>[];
        final sList = <String>[];
        for (final item in rawAnggota) {
          if (item is Map<String, dynamic>) {
            final nama = item['nama'] as String? ?? '';
            final isGuru = item['guru'] as bool? ?? false;
            if (nama.isEmpty) continue;
            if (isGuru) {
              tList.add(nama);
            } else {
              sList.add(nama);
            }
          }
        }
        _teachers[code] = tList;
        _students[code] = sList;
        if (tList.isNotEmpty) {
          teacherName = tList.first;
        }
      }

      if (materiRes.statusCode == 200) {
        final rawMateri =
            jsonDecode(materiRes.body) as List<dynamic>? ?? const [];
        _materi[code] = rawMateri
            .map(
              (e) => MateriModel.fromJson(
                e as Map<String, dynamic>,
                author: teacherName,
              ),
            )
            .toList();
      }

      if (tugasRes.statusCode == 200) {
        final rawTugas =
            jsonDecode(tugasRes.body) as List<dynamic>? ?? const [];
        _tugas[code] = rawTugas
            .map(
              (e) => TugasPengajarModel.fromJson(
                e as Map<String, dynamic>,
                author: teacherName,
              ),
            )
            .toList();
      }

      notifyListeners();
    } catch (_) {}
  }

  /// Memuat daftar pengumpulan tugas dari `GET /kelas/:kode/postingan/:id/kumpul`.
  Future<void> fetchPengumpulan(ClassModel c, String tugasId) async {
    final code = c.code;
    if (code == null || code.isEmpty) return;

    try {
      final res = await _client.get(
        _client.uri('/kelas/$code/postingan/$tugasId/kumpul'),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>? ?? const [];
        final submitted = data
            .map((e) => PengumpulanModel.fromJson(e as Map<String, dynamic>))
            .toList();

        final submittedNames = submitted
            .map((e) => e.studentName.toLowerCase())
            .toSet();
        final allStudents = _students[code] ?? const <String>[];
        final assigned = <PengumpulanModel>[
          for (final name in allStudents)
            if (!submittedNames.contains(name.toLowerCase()))
              PengumpulanModel(
                studentName: name,
                status: PengumpulanStatus.ditugaskan,
              ),
        ];

        _pengumpulan[tugasId] = [...submitted, ...assigned];
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> addMateri(ClassModel c, MateriModel m) async {
    final code = c.code;
    if (code == null || code.isEmpty) return;

    _materi.putIfAbsent(code, () => []).insert(0, m);
    notifyListeners();

    try {
      final lampiranPaths = await _client.uploadAttachments(m.lampiran);
      final res = await _client.post(
        _client.uri('/kelas/$code/posts'),
        body: jsonEncode({
          'judul': m.title,
          'deskripsi': m.description,
          'lampiran': lampiranPaths,
          'tipe': 1,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        await fetchClassContent(c);
      }
    } catch (_) {}
  }

  Future<void> updateMateri(
    ClassModel c,
    MateriModel old, {
    required String title,
    required String description,
  }) async {
    final code = c.code;
    if (code == null || code.isEmpty) return;

    final list = _materi[code];
    final i = list?.indexOf(old) ?? -1;
    if (i != -1) {
      list![i] = old.copyWith(title: title, description: description);
      notifyListeners();
    }

    if (old.id == null) return;
    try {
      final lampiranPaths = await _client.uploadAttachments(old.lampiran);
      await _client.patch(
        _client.uri('/kelas/$code/postingan/${old.id}'),
        body: jsonEncode({
          'judul': title,
          'deskripsi': description,
          'lampiran': lampiranPaths,
          'tipe': 1,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (_) {}
  }

  Future<void> deleteMateri(ClassModel c, MateriModel m) async {
    final code = c.code;
    if (code == null || code.isEmpty) return;

    _materi[code]?.remove(m);
    notifyListeners();

    if (m.id == null) return;
    try {
      await _client.delete(_client.uri('/kelas/$code/postingan/${m.id}'));
    } catch (_) {}
  }

  Future<String> addTugas(ClassModel c, TugasPengajarModel t) async {
    final code = c.code;
    if (code == null || code.isEmpty) return t.id;

    _tugas.putIfAbsent(code, () => []).insert(0, t);
    notifyListeners();

    try {
      final lampiranPaths = await _client.uploadAttachments(t.lampiran);
      final res = await _client.post(
        _client.uri('/kelas/$code/posts'),
        body: jsonEncode({
          'judul': t.title,
          'deskripsi': t.description,
          'lampiran': lampiranPaths,
          'tipe': 2,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        await fetchClassContent(c);
        final latest = _tugas[code];
        if (latest != null && latest.isNotEmpty) {
          return latest.first.id;
        }
      }
    } catch (_) {}
    return t.id;
  }

  Future<void> updateTugas(ClassModel c, TugasPengajarModel updated) async {
    final code = c.code;
    if (code == null || code.isEmpty) return;

    final list = _tugas[code];
    final i = list?.indexWhere((t) => t.id == updated.id) ?? -1;
    if (i != -1) {
      list![i] = updated;
      notifyListeners();
    }

    try {
      final lampiranPaths = await _client.uploadAttachments(updated.lampiran);
      await _client.patch(
        _client.uri('/kelas/$code/postingan/${updated.id}'),
        body: jsonEncode({
          'judul': updated.title,
          'deskripsi': updated.description,
          'lampiran': lampiranPaths,
          'tipe': 2,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (_) {}
  }

  Future<void> deleteTugas(ClassModel c, String id) async {
    final code = c.code;
    if (code == null || code.isEmpty) return;

    _tugas[code]?.removeWhere((t) => t.id == id);
    _pengumpulan.remove(id);
    notifyListeners();

    try {
      await _client.delete(_client.uri('/kelas/$code/postingan/$id'));
    } catch (_) {}
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

  bool addTeacher(ClassModel c, String name) => _addName(_teacherList(c), name);
  bool addStudent(ClassModel c, String name) => _addName(_studentList(c), name);

  bool _addName(List<String> list, String name) {
    final exists = list.any((n) => n.toLowerCase() == name.toLowerCase());
    if (exists) return false;
    list.add(name);
    notifyListeners();
    return true;
  }

  void removeTeacher(ClassModel c, String name) {
    _teacherList(c).remove(name);
    notifyListeners();
  }

  void removeStudent(ClassModel c, String name) {
    _studentList(c).remove(name);
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

  Future<ClassModel> resetCode(ClassModel old) async {
    final code = old.code;
    if (code == null || code.isEmpty) return old;

    try {
      final res = await _client.post(_client.uri('/kelas/$code/reset-kode'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final newCode = data['kode_kelas'] as String? ?? code;
        final updated = ClassModel(
          id: old.id,
          title: old.title,
          grade: old.grade,
          imagePath: old.imagePath,
          code: newCode,
        );

        final i = _teaching.indexWhere((x) => x.code == code);
        if (i != -1) _teaching[i] = updated;

        final materiList = _materi.remove(code);
        if (materiList != null) _materi[newCode] = materiList;

        final tugasList = _tugas.remove(code);
        if (tugasList != null) _tugas[newCode] = tugasList;

        final teacherList = _teachers.remove(code);
        if (teacherList != null) _teachers[newCode] = teacherList;

        final studentList = _students.remove(code);
        if (studentList != null) _students[newCode] = studentList;

        notifyListeners();
        return updated;
      }
    } catch (_) {}
    return old;
  }

  Future<void> deleteClass(ClassModel target) async {
    final code = target.code;
    _teaching.removeWhere((c) => c.code == code || c == target);
    _materi.remove(code);
    for (final t in _tugas[code] ?? const <TugasPengajarModel>[]) {
      _pengumpulan.remove(t.id);
    }
    _tugas.remove(code);
    _teachers.remove(code);
    _students.remove(code);
    notifyListeners();

    if (code == null || code.isEmpty) return;
    try {
      await _client.delete(_client.uri('/kelas/$code'));
    } catch (_) {}
  }

  Future<void> createClass({
    required String title,
    required String grade,
  }) async {
    final tingkat = KelasModel.parseTingkat(grade);
    try {
      final res = await _client.post(
        _client.uri('/kelas'),
        body: jsonEncode({
          'nama': title,
          'tingkat': tingkat,
          'tahun_ajaran': '2026/2027',
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        await fetchTeachingClasses();
      }
    } catch (_) {}
  }

  Future<void> updateClass(
    ClassModel old, {
    required String title,
    required String grade,
  }) async {
    final code = old.code;
    final i = _teaching.indexWhere((c) => c.code == code || c == old);
    if (i != -1) {
      _teaching[i] = ClassModel(
        id: old.id,
        title: title,
        grade: grade,
        imagePath:
            old.imagePath ?? AppAssets.covers[i % AppAssets.covers.length],
        code: code,
      );
      notifyListeners();
    }

    if (code == null || code.isEmpty) return;
    try {
      await _client.patch(
        _client.uri('/kelas/$code'),
        body: jsonEncode({
          'nama': title,
          'tingkat': KelasModel.parseTingkat(grade),
          'tahun_ajaran': '2026/2027',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (_) {}
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
