import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/ui/core/app_routes.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/dashboard/widgets/empty_class_view.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/pengajar_detail_screen.dart';
import 'package:path_mobile/ui/pengajar/widgets/create_class_form.dart';
import 'package:path_mobile/ui/pengajar/widgets/teaching_classes_view.dart';
import 'package:path_mobile/utils/copy_helper.dart';

class PengajarScreen extends StatefulWidget {
  final PengajarController controller;

  const PengajarScreen({super.key, required this.controller});

  @override
  State<PengajarScreen> createState() => _PengajarScreenState();
}

class _PengajarScreenState extends State<PengajarScreen> {
  bool _showForm = false;

  PengajarController get _ctrl => widget.controller;

  void _openForm() => setState(() => _showForm = true);
  void _closeForm() => setState(() => _showForm = false);

  String _formatGrade(String grade) => grade.isEmpty ? '' : 'Kelas $grade';

  Future<void> _createClass(String name, String grade) async {
    final err = await _ctrl.createClass(
      title: name,
      grade: _formatGrade(grade),
    );
    if (!mounted) return;
    _closeForm();
    if (err != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(err)));
    }
  }

  void _copyLink(ClassModel c) {
    copyWithNotice(
      context,
      text: c.inviteLink,
      message: 'Link undangan kelas disalin',
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      breadcrumb: const ['Pengajar'],
      child: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          if (_showForm) {
            return CreateClassForm(
              onCreate: _createClass,
              onCancel: _closeForm,
            );
          }

          final classes = _ctrl.teachingClasses;
          if (classes.isEmpty) {
            return EmptyClassView(
              message: 'Anda belum membuat kelas',
              joinLabel: 'Buat Kelas',
              onJoinClass: _openForm,
            );
          }

          return TeachingClassesView(
            classes: classes,
            onCreate: _openForm,
            onOpen: (c) => openPage(
              context,
              breadcrumb: ['Pengajar', c.title],
              page: PengajarDetailScreen(controller: _ctrl, classData: c),
              routeName: AppRoutes.pengajarDetail,
            ),
            onCopyLink: _copyLink,
          );
        },
      ),
    );
  }
}
