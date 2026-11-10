import 'package:flutter/material.dart';
import 'package:path_mobile/ui/register/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController _controller;

  const new({super.key, required this._controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(64)),
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                spacing: 32,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BackButton(),
                      Expanded(
                        child: Text(
                          "New Account",
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
                        decoration: InputDecoration(labelText: "Username"),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Password"),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
