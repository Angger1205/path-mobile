import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/profil/crop_foto_screen.dart';
import 'package:path_mobile/ui/profil/profil_controller.dart';
import 'package:path_mobile/ui/profil/widgets/profil_avatar.dart';
import 'package:path_mobile/ui/profil/widgets/profil_header.dart';

class EditProfilScreen extends StatefulWidget {
  final ProfilController controller;

  const EditProfilScreen({super.key, required this.controller});

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  ProfilController get _ctrl => widget.controller;
  late final TextEditingController _nameController;
  Uint8List? _photo;

  bool get _canSave => _nameController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _ctrl.name);
    _photo = _ctrl.photo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (file == null || !mounted) return;

    final bytes = await file.readAsBytes();
    if (!mounted) return;

    final cropped = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) => PageFrame(
          breadcrumb: const ['Profil', 'Edit Profil', 'Potong Foto'],
          child: CropFotoScreen(image: bytes),
        ),
      ),
    );
    if (cropped == null || !mounted) return;

    setState(() => _photo = cropped);
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final err = await _ctrl.update(
      name: _nameController.text.trim(),
      photo: _photo,
    );
    if (!mounted) return;

    navigator.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(err ?? 'Profil disimpan')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfilHeader(showBack: true),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              InkWell(
                onTap: _pickPhoto,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      ProfilAvatar(photo: _photo),
                      const SizedBox(width: 12),
                      const Text(
                        'Edit foto profil',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black26),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.manage_accounts_outlined,
                          size: 16,
                          color: AppColors.text,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Display name',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.text,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Edit display name',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                        ),
                        isDense: true,
                        filled: false,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black26),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: _canSave ? _save : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
