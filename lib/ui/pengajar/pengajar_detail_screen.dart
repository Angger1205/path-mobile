import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/ui/core/app_button_styles.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kelas/widgets/materi_card.dart';
import 'package:path_mobile/ui/pengajar/buat_materi_screen.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/pengajar_materi_detail_screen.dart';
import 'package:path_mobile/ui/pengajar/widgets/class_code_card.dart';
import 'package:path_mobile/ui/pengajar/widgets/edit_materi_dialog.dart';
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
  ClassModel get _class => widget.classData;

  @override
  void initState() {
    super.initState();
    _ctrl.fetchClassContent(_class);
  }

  Future<void> _editMateri(MateriModel m) async {
    final result = await showEditMateriDialog(
      context,
      className: _class.title,
      title: m.title,
      description: m.description,
    );
    if (result == null) return;
    final err = await _ctrl.updateMateri(
      _class,
      m,
      title: result.title,
      description: result.description,
    );
    if (err != null && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildMateriTab(),
                PengajarTugasTab(controller: _ctrl, classData: _class),
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
                    icon: const Icon(Icons.add_box_outlined, size: 18),
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
                          menuLabels: const ['Edit'],
                          onMenuItemSelected: (_) => _editMateri(m),
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
