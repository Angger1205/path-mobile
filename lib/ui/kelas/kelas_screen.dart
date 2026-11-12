import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';
import 'package:path_mobile/ui/kelas/widgets/registered_classes_view.dart';

class KelasScreen extends StatelessWidget {
  final KelasController controller;

  const KelasScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      breadcrumb: const ['Kelas'],
      child: RegisteredClassesView(
        controller: controller,
        breadcrumbRoot: 'Kelas',
        emptyMessage: 'Anda belum bergabung kelas manapun',
      ),
    );
  }
}
