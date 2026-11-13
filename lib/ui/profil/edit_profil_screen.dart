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
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  Uint8List? _photo;
  bool _saving = false;

  bool get _hasChanges =>
      (_photo != null && !identical(_photo, _ctrl.photo)) ||
      _emailController.text.trim() != _ctrl.email ||
      _phoneController.text.trim() != _ctrl.phone;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: _ctrl.email);
    _phoneController = TextEditingController(text: _ctrl.phone);
    _photo = _ctrl.photo;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
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
    setState(() => _saving = true);
    String? err;

    if (_photo != null && !identical(_photo, _ctrl.photo)) {
      err = await _ctrl.updateProfilePicture(_photo!);
    }

    final email = _emailController.text.trim();
    if (err == null && email.isNotEmpty && email != _ctrl.email) {
      err = await _ctrl.updateEmail(email);
    }

    final phone = _phoneController.text.trim();
    if (err == null && phone.isNotEmpty && phone != _ctrl.phone) {
      err = await _ctrl.updatePhone(phone);
    }

    if (!mounted) return;
    setState(() => _saving = false);

    if (err == null) Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(err ?? 'Profil disimpan')));
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
              _buildField(
                icon: Icons.mail_outline,
                label: 'Email',
                hint: 'Masukkan email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black26),
              _buildField(
                icon: Icons.phone_outlined,
                label: 'Phone',
                hint: 'Contoh: +628123456789',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const Divider(height: 1, thickness: 1, color: Colors.black26),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton(
                  onPressed: _hasChanges && !_saving ? _save : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                  child: Text(_saving ? 'Menyimpan...' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.text),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 13, color: AppColors.text),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
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
    );
  }
}
