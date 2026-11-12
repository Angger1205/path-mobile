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
  Future<void> fetchPengumpulan(ClassModel c, String tugasId) =>
      _repo.fetchPengumpulan(c, tugasId);

  List<MateriModel> materiOf(ClassModel c) => _repo.materiOf(c);
  Future<void> addMateri(ClassModel c, MateriModel m) => _repo.addMateri(c, m);
  Future<void> updateMateri(
    ClassModel c,
    MateriModel old, {
    required String title,
    required String description,
  }) => _repo.updateMateri(c, old, title: title, description: description);
  Future<void> deleteMateri(ClassModel c, MateriModel m) =>
      _repo.deleteMateri(c, m);

  List<TugasPengajarModel> tugasOf(ClassModel c) => _repo.tugasOf(c);
  TugasPengajarModel? tugasById(ClassModel c, String id) =>
      _repo.tugasById(c, id);
  Future<String> addTugas(ClassModel c, TugasPengajarModel t) =>
      _repo.addTugas(c, t);
  Future<void> updateTugas(ClassModel c, TugasPengajarModel updated) =>
      _repo.updateTugas(c, updated);
  Future<void> deleteTugas(ClassModel c, String id) =>
      _repo.deleteTugas(c, id);

  List<PengumpulanModel> pengumpulanOf(String tugasId) =>
      _repo.pengumpulanOf(tugasId);
  void saveScores(String tugasId, Map<String, int> scores) =>
      _repo.saveScores(tugasId, scores);

  List<String> teachersOf(ClassModel c) => _repo.teachersOf(c);
  List<String> studentsOf(ClassModel c) => _repo.studentsOf(c);
  bool addTeacher(ClassModel c, String name) => _repo.addTeacher(c, name);
  bool addStudent(ClassModel c, String name) => _repo.addStudent(c, name);
  void removeTeacher(ClassModel c, String name) => _repo.removeTeacher(c, name);
  void removeStudent(ClassModel c, String name) => _repo.removeStudent(c, name);

  void setAcceptSubmissions(ClassModel c, String id, bool value) =>
      _repo.setAcceptSubmissions(c, id, value);
  Future<ClassModel> resetCode(ClassModel old) => _repo.resetCode(old);
  Future<void> deleteClass(ClassModel target) => _repo.deleteClass(target);
  Future<void> createClass({required String title, required String grade}) =>
      _repo.createClass(title: title, grade: grade);
  Future<void> updateClass(
    ClassModel old, {
    required String title,
    required String grade,
  }) => _repo.updateClass(old, title: title, grade: grade);

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
