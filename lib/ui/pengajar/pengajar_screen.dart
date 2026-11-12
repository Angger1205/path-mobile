import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/ui/core/app_routes.dart';
import 'package:path_mobile/ui/core/confirm_dialog.dart';
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
  ClassModel? _editing;

  PengajarController get _ctrl => widget.controller;

  void _openForm() => setState(() => _showForm = true);

  void _closeForm() => setState(() {
    _showForm = false;
    _editing = null;
  });

  String _formatGrade(String grade) => grade.isEmpty ? '' : 'Kelas $grade';

  void _createClass(String name, String grade) {
    _ctrl.createClass(title: name, grade: _formatGrade(grade));
    _closeForm();
  }

  void _saveEdit(String name, String grade) {
    _ctrl.updateClass(_editing!, title: name, grade: _formatGrade(grade));
    _closeForm();
  }

  void _copyLink(ClassModel c) {
    copyWithNotice(
      context,
      text: c.inviteLink,
      message: 'Link undangan kelas disalin',
    );
  }

  Future<void> _confirmDelete(ClassModel c) async {
    final yes = await showConfirmDialog(
      context,
      title: 'Hapus Kelas',
      message: 'Apakah anda yakin ingin menghapus kelas',
    );
    if (yes) _ctrl.deleteClass(c);
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      breadcrumb: const ['Pengajar'],
      child: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          if (_editing != null) {
            return CreateClassForm(
              title: 'Edit Kelas',
              submitLabel: 'Simpan',
              initialName: _editing!.title,
              initialGrade: _editing!.grade.replaceFirst('Kelas ', ''),
              onCreate: _saveEdit,
              onCancel: _closeForm,
            );
          }

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
            onEdit: (c) => setState(() => _editing = c),
            onDelete: _confirmDelete,
          );
        },
      ),
    );
  }
}
