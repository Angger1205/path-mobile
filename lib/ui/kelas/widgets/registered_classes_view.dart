import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/dashboard/widgets/empty_class_view.dart';
import 'package:path_mobile/ui/kelas/class_detail_screen.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';
import 'package:path_mobile/ui/kelas/widgets/join_class_view.dart';
import 'package:path_mobile/ui/kelas/widgets/joined_classes_view.dart';

/// Isi halaman daftar kelas: dipakai bersama oleh Beranda dan Kelas.
/// Mengurus form gabung kelas, kondisi kosong, dan daftar kelas.
class RegisteredClassesView extends StatefulWidget {
  final KelasController controller;
  final String breadcrumbRoot; // 'Beranda' atau 'Kelas': awal jejak breadcrumb
  final String emptyMessage; // teks saat belum punya kelas
  final String? emptyHint; // teks tebal di bawahnya, boleh kosong
  final VoidCallback? onAddClass; // kosong = tombol Tambah Kelas tidak tampil
  final Widget? listTopBar; // pengganti baris judul bawaan, boleh kosong

  const RegisteredClassesView({
    super.key,
    required this.controller,
    required this.breadcrumbRoot,
    required this.emptyMessage,
    this.emptyHint,
    this.onAddClass,
    this.listTopBar,
  });

  @override
  State<RegisteredClassesView> createState() => _RegisteredClassesViewState();
}

class _RegisteredClassesViewState extends State<RegisteredClassesView> {
  bool _isJoining = false;

  void _openJoinForm() => setState(() => _isJoining = true);
  void _closeJoinForm() => setState(() => _isJoining = false);

  void _openClass(ClassModel data) {
    final trail = [widget.breadcrumbRoot, data.title];
    openPage(
      context,
      breadcrumb: trail,
      page: ClassDetailScreen(
        controller: widget.controller,
        classData: data,
        breadcrumb: trail,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isJoining) {
      return JoinClassView(
        controller: widget.controller,
        onCancel: _closeJoinForm,
        onJoined: _closeJoinForm,
      );
    }

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final classes = widget.controller.joinedClasses;

        if (classes.isEmpty) {
          return EmptyClassView(
            message: widget.emptyMessage,
            hint: widget.emptyHint,
            onJoinClass: _openJoinForm,
            onAddClass: widget.onAddClass,
          );
        }

        return JoinedClassesView(
          controller: widget.controller,
          classes: classes,
          onJoinClass: _openJoinForm,
          onOpenClass: _openClass,
          topBar: widget.listTopBar,
        );
      },
    );
  }
}
