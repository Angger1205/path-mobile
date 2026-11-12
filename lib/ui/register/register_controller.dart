import 'package:flutter/material.dart';
import 'package:path_mobile/data/register/register_repository.dart';

class RegisterController extends ChangeNotifier {
  final RegisterRepository _repo;
  final Future<void> Function()? onAuthenticated;

  RegisterController(this._repo, {this.onAuthenticated});

  RegisterRepository get repo => _repo;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> register() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'Semua kolom wajib diisi';
      notifyListeners();
      return false;
    }
    if (password.length < 8) {
      _errorMessage = 'Password minimal 8 karakter';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final err = await _repo.register(
      username: username,
      email: email,
      password: password,
    );
    if (err == null && onAuthenticated != null) {
      await onAuthenticated!();
    }

    _isLoading = false;
    _errorMessage = err;
    notifyListeners();

    return err == null;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
