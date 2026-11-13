import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/kelas_repository.dart';

class KelasController {
  final KelasRepository _repo;

  KelasController(this._repo);

  List<KelasModel>? _listKelas;
  List<KelasModel> get listKelas => _listKelas ?? [];

  Future<void> getListKelas() async {
    final (listKelas, err) = await _repo.getListKelas();
    if (err != null) {
      throw err;
    }
    _listKelas = listKelas;
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
}
