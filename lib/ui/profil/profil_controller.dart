import 'package:flutter/foundation.dart';
import 'package:path_mobile/data/profil/profil_repository.dart';

class ProfilController extends ChangeNotifier {
  final ProfilRepository _repo;

  ProfilController(this._repo) {
    _repo.addListener(notifyListeners);
  }

  String get name => _repo.name;
  String get email => _repo.email;
  String get phone => _repo.phone;
  Uint8List? get photo => _repo.photo;

  Future<String?> fetchProfile() => _repo.fetchProfile();

  Future<String?> update({required String name, Uint8List? photo}) =>
      _repo.update(name: name, photo: photo);

  Future<String?> updateEmail(String email) => _repo.updateEmail(email);

  Future<String?> updatePhone(String phone) => _repo.updatePhone(phone);

  Future<String?> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) => _repo.resetPassword(oldPassword: oldPassword, newPassword: newPassword);

  @override
  void dispose() {
    _repo.removeListener(notifyListeners);
    super.dispose();
  }
}
