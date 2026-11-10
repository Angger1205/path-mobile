import 'package:flutter/material.dart';
import 'package:path_mobile/ui/profil/profil_controller.dart';

class ProfilScreen extends StatelessWidget {
  final ProfilController _controller;

  const new({super.key, required this._controller});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profil'));
  }
}
