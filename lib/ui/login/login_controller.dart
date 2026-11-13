import 'package:flutter/material.dart';
import 'package:path_mobile/data/login/login_repository.dart';

class LoginController extends ChangeNotifier {
  final LoginRepository _repo;

  LoginController(this._repo);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _isLoading = false;
      _errorMessage = 'email atau password tidak boleh kosong';
      notifyListeners();
      return false;
    }

    final err = await _repo.login(
      emailController.text,
      passwordController.text,
    );

    _isLoading = false;
    _errorMessage = err;
    notifyListeners();

    return err == null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
