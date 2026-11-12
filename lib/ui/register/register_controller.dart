import 'package:flutter/material.dart';
import 'package:path_mobile/data/register/register_repository.dart';

class RegisterController extends ChangeNotifier {
  final RegisterRepository _repo;

  RegisterController(this._repo);

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> register() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _isLoading = false;
      _errorMessage = 'username, email, atau password tidak boleh kosong';
      notifyListeners();
      return false;
    }

    final err = await _repo.register(
      usernameController.text,
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
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
