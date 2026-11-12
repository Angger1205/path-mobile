import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/ui/core/app_assets.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/confirm_dialog.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/core/png_icon.dart';
import 'package:path_mobile/ui/kelas/widgets/materi_card.dart';
import 'package:path_mobile/ui/pengajar/buat_materi_screen.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/pengajar_materi_detail_screen.dart';
import 'package:path_mobile/ui/pengajar/widgets/class_code_card.dart';
import 'package:path_mobile/ui/pengajar/widgets/edit_materi_dialog.dart';
import 'package:path_mobile/ui/pengajar/widgets/pengajar_members_tab.dart';
import 'package:path_mobile/ui/pengajar/widgets/pengajar_tugas_tab.dart';
import 'package:path_mobile/utils/copy_helper.dart';

class PengajarDetailScreen extends StatefulWidget {
  final PengajarController controller;
  final ClassModel classData;

  const PengajarDetailScreen({
    super.key,
    required this.controller,
    required this.classData,
  });

  @override
  State<PengajarDetailScreen> createState() => _PengajarDetailScreenState();
}

class _PengajarDetailScreenState extends State<PengajarDetailScreen> {
  PengajarController get _ctrl => widget.controller;
  late ClassModel _class = widget.classData;

  @override
  void initState() {
    super.initState();
    _ctrl.fetchClassContent(_class);
  }

  Future<void> _resetCode() async {
    final yes = await showConfirmDialog(
      context,
      title: 'Reset Kode Kelas',
      message:
          'Kode dan link undangan yang lama tidak akan berlaku lagi. Lanjutkan?',
    );
    if (!yes || !mounted) return;

    final updated = await _ctrl.resetCode(_class);
    if (!mounted) return;
    setState(() => _class = updated);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Kode kelas direset')));
  }

  Future<void> _editMateri(MateriModel m) async {
    final result = await showEditMateriDialog(
      context,
      className: _class.title,
      title: m.title,
      description: m.description,
    );
    if (result == null) return;
    _ctrl.updateMateri(
      _class,
      m,
      title: result.title,
      description: result.description,
    );
  }

  Future<void> _deleteMateri(MateriModel m) async {
    final yes = await showConfirmDialog(
      context,
      title: 'Hapus Materi',
      message: 'Apakah anda yakin ingin menghapus materi',
    );
    if (yes) _ctrl.deleteMateri(_class, m);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          BackTitleRow(title: _class.title),
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppColors.text,
            labelColor: AppColors.text,
            unselectedLabelColor: AppColors.secondaryText,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 13),
            dividerColor: Colors.transparent,
            padding: const EdgeInsets.only(left: 8),
            tabs: const [
              Tab(text: 'Materi'),
              Tab(text: 'Tugas'),
              Tab(text: 'Anggota'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMateriTab(),
                PengajarTugasTab(controller: _ctrl, classData: _class),
                PengajarMembersTab(controller: _ctrl, classData: _class),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriTab() {
    return ListenableBuilder(
      listenable: _ctrl,
      builder: (context, _) {
        final materi = _ctrl.materiOf(_class);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  ClassCodeCard(
                    code: _class.code ?? '',
                    className: _class.title,
                    onCopyLink: () => copyWithNotice(
                      context,
                      text: _class.inviteLink,
                      message: 'Link undangan kelas disalin',
                    ),
                    onCopyCode: () => copyWithNotice(
                      context,
                      text: _class.code ?? '',
                      message: 'Kode kelas disalin',
                    ),
                    onReset: _resetCode,
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    style: AppButtonStyles.softCompact,
                    onPressed: () => openPage(
                      context,
                      breadcrumb: ['Pengajar', _class.title, 'Buat Materi'],
                      page: BuatMateriScreen(
                        controller: _ctrl,
                        classData: _class,
                      ),
                    ),
                    icon: const PngIcon(
                      AppAssets.iconTambah,
                      size: 18,
                      fallback: Icons.add_box_outlined,
                    ),
                    label: const Text('Buat Materi'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: materi.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada materi',
                        style: TextStyle(color: AppColors.secondaryText),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: materi.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final m = materi[i];
                        return MateriCard(
                          data: m,
                          onTap: () => openPage(
                            context,
                            breadcrumb: ['Pengajar', _class.title, m.title],
                            page: PengajarMateriDetailScreen(materi: m),
                          ),
                          menuLabels: const ['Edit', 'Hapus'],
                          onMenuItemSelected: (index) {
                            switch (index) {
                              case 0:
                                _editMateri(m);
                              case 1:
                                _deleteMateri(m);
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
