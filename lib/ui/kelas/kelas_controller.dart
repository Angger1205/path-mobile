import 'package:flutter/foundation.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/kelas_repository.dart';
import 'package:path_mobile/data/kelas/lampiran_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/data/kelas/tugas_model.dart';

class KelasController extends ChangeNotifier {
  final KelasRepository _repo;

  KelasController(this._repo) {
    _repo.addListener(notifyListeners);
  }

  List<KelasModel>? _listKelas;
  List<KelasModel> get listKelas => _listKelas ?? [];

  List<ClassModel> get joinedClasses => _repo.joinedClasses;
  List<MateriModel> get materiList => _repo.materiList;
  List<TugasModel> get tugasItems => _repo.tugasItems;
  List<String> get teachers => _repo.teachers;
  List<String> get students => _repo.students;

  Future<String?> fetchJoinedClasses() => _repo.fetchJoinedClasses();
  Future<void> fetchClassDetail(String kodeKelas) =>
      _repo.fetchClassDetail(kodeKelas);
  Future<bool> joinByCode(String code) => _repo.joinByCode(code);
  Future<void> leaveClass(ClassModel classModel) => _repo.leaveClass(classModel);
  TugasModel? tugasById(String id) => _repo.tugasById(id);
  void updateTugasStatus(String id, TugasStatus status) =>
      _repo.updateTugasStatus(id, status);
  Future<void> submitTugas(String id, List<LampiranModel> added) =>
      _repo.submitTugas(id, added);
  Future<String> askAi(String question, String? mode) =>
      _repo.askAi(question, mode);

  Future<void> getListKelas() async {
    final (listKelas, err) = await _repo.getListKelas();
    if (err != null) {
      throw err;
    }
    _listKelas = listKelas;
    notifyListeners();
  }

  Future<KelasModel?> getKelas(int id) async {
    try {
      final (kelas, err) = await _repo.getKelas(id);
      if (err != null) {
        throw err;
      }

      return kelas;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _repo.removeListener(notifyListeners);
    super.dispose();
  }
}
