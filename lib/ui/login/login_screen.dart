import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_mobile/ui/login/login_controller.dart';

class LoginScreen extends StatefulWidget {
  final LoginController _controller;

  const LoginScreen({super.key, required this._controller});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    // Like Go's `defer controller.Close()`
    widget._controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final res = await widget._controller.login();
    if (res && mounted) {
      context.go('/beranda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(64)),
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              // Rebuilds this subtree whenever widget._controller calls notifyListeners()
              child: ListenableBuilder(
                listenable: widget._controller,
                builder: (context, _) {
                  final ctrl = widget._controller;

                  return Column(
                    spacing: 32,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BackButton(),
                          Expanded(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            child: Icon(Icons.person),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20,
                        children: [
                          TextField(
                            controller: ctrl.emailController,
                            enabled: !ctrl.isLoading,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: "Email",
                            ),
                          ),
                          TextField(
                            controller: ctrl.passwordController,
                            enabled: !ctrl.isLoading,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                          ),
                          if (ctrl.errorMessage != null)
                            Text(
                              ctrl.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: ctrl.isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: ctrl.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Login'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
