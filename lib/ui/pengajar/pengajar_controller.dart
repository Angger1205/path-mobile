import 'package:flutter/foundation.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/data/pengajar/pengajar_repository.dart';
import 'package:path_mobile/data/pengajar/pengumpulan_model.dart';
import 'package:path_mobile/data/pengajar/tugas_pengajar_model.dart';

class PengajarController extends ChangeNotifier {
  final PengajarRepository _repo;

  PengajarController(this._repo) {
    _repo.addListener(notifyListeners);
  }

  List<ClassModel> get teachingClasses => _repo.teachingClasses;

  Future<String?> fetchTeachingClasses() => _repo.fetchTeachingClasses();
  Future<void> fetchClassContent(ClassModel c) => _repo.fetchClassContent(c);
  Future<String?> createClass({required String title, required String grade}) =>
      _repo.createClass(title: title, grade: grade);

  List<MateriModel> materiOf(ClassModel c) => _repo.materiOf(c);
  Future<String?> addMateri(ClassModel c, MateriModel m) =>
      _repo.addMateri(c, m);
  Future<String?> updateMateri(
    ClassModel c,
    MateriModel old, {
    required String title,
    required String description,
  }) => _repo.updateMateri(c, old, title: title, description: description);

  List<TugasPengajarModel> tugasOf(ClassModel c) => _repo.tugasOf(c);
  TugasPengajarModel? tugasById(ClassModel c, String id) =>
      _repo.tugasById(c, id);
  Future<String?> addTugas(ClassModel c, TugasPengajarModel t) =>
      _repo.addTugas(c, t);
  Future<String?> updateTugas(ClassModel c, TugasPengajarModel updated) =>
      _repo.updateTugas(c, updated);

  List<PengumpulanModel> pengumpulanOf(String tugasId) =>
      _repo.pengumpulanOf(tugasId);
  void saveScores(String tugasId, Map<String, int> scores) =>
      _repo.saveScores(tugasId, scores);
  void setAcceptSubmissions(ClassModel c, String id, bool value) =>
      _repo.setAcceptSubmissions(c, id, value);

  Future<MateriModel> generateAiMateri({
    required String title,
    required String prompt,
    String? mode,
  }) => _repo.generateAiMateri(title: title, prompt: prompt, mode: mode);

  Future<Map<String, int>> generateAiKoreksi(
    List<PengumpulanModel> students,
  ) => _repo.generateAiKoreksi(students);

  @override
  void dispose() {
    _repo.removeListener(notifyListeners);
    super.dispose();
  }
}
