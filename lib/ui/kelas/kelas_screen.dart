import 'package:flutter/material.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';

class KelasScreen extends StatelessWidget {
  final KelasController _controller;

  const new({super.key, required this._controller});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Kelas'));
  }
}
