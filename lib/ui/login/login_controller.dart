import 'package:flutter/material.dart';
import 'package:path_mobile/data/login/login_repository.dart';

class LoginController extends ChangeNotifier {
  final LoginRepository _repo;
  final Future<void> Function()? onAuthenticated;

  LoginController(this._repo, {this.onAuthenticated});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan password wajib diisi';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final err = await _repo.login(email, password);
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
