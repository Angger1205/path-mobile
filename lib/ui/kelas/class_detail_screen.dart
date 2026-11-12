import 'package:flutter/material.dart';
import 'package:path_mobile/data/kelas/kelas_model.dart';
import 'package:path_mobile/data/kelas/materi_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';
import 'package:path_mobile/ui/kelas/materi_detail_screen.dart';
import 'package:path_mobile/ui/kelas/widgets/materi_card.dart';
import 'package:path_mobile/ui/kelas/widgets/members_tab.dart';
import 'package:path_mobile/ui/kelas/widgets/tugas_tab.dart';

class ClassDetailScreen extends StatefulWidget {
  final KelasController controller;
  final ClassModel classData;
  final List<String> breadcrumb;

  const ClassDetailScreen({
    super.key,
    required this.controller,
    required this.classData,
    required this.breadcrumb,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  @override
  void initState() {
    super.initState();
    final code = widget.classData.code;
    if (code != null && code.isNotEmpty) {
      widget.controller.fetchClassDetail(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          BackTitleRow(title: widget.classData.title),
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
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                final materi = widget.controller.materiList;
                return TabBarView(
                  children: [
                    _buildMateriList(materi),
                    TugasTab(
                      controller: widget.controller,
                      breadcrumb: widget.breadcrumb,
                    ),
                    MembersTab(controller: widget.controller),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriList(List<MateriModel> materi) {
    if (materi.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada materi',
          style: TextStyle(color: AppColors.secondaryText),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: materi.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => MateriCard(
        data: materi[index],
        onTap: () => openPage(
          context,
          breadcrumb: [...widget.breadcrumb, materi[index].title],
          page: MateriDetailScreen(
            controller: widget.controller,
            materi: materi[index],
          ),
        ),
      ),
    );
  }
}
