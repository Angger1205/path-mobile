import 'package:flutter/material.dart';
import 'package:path_mobile/ui/kalender/kalender_controller.dart';

class KalenderScreen extends StatelessWidget {
  final KalenderController _controller;
  const new({super.key, required this._controller});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Kalender'));
  }
}
