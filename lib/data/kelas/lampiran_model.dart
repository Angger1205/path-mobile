import 'dart:typed_data';

enum LampiranType { file, link }

class LampiranModel {
  final LampiranType type;
  final String name; // nama file, atau tulisan "Link"
  final String detail; // "PDF" untuk file, alamat untuk link
  final Uint8List? bytes; // isi file lokal saat baru dipilih dari perangkat
  final String? serverPath; // path di server seperti "/uploads/..."

  const LampiranModel({
    required this.type,
    required this.name,
    required this.detail,
    this.bytes,
    this.serverPath,
  });

  factory LampiranModel.fromRaw(String raw) {
    final trimmed = raw.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return LampiranModel(
        type: LampiranType.link,
        name: 'Link',
        detail: trimmed,
      );
    }
    final fileName = trimmed.split('/').last;
    final ext = fileName.contains('.')
        ? fileName.split('.').last.toUpperCase()
        : 'FILE';
    return LampiranModel(
      type: LampiranType.file,
      name: fileName.isEmpty ? trimmed : fileName,
      detail: ext,
      serverPath: trimmed.startsWith('/') ? trimmed : null,
    );
  }
}
