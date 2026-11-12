import 'package:path_mobile/data/kelas/lampiran_model.dart';

class TugasPengajarModel {
  final String id; // pengenal unik, untuk mencari tugas ini
  final String title;
  final String description;
  final String author;
  final DateTime postedAt;
  final DateTime? dueDate; // tanda ? = boleh kosong (tenggat opsional)
  final int points;
  final bool acceptSubmissions; // switch "Menerima kiriman"
  final List<LampiranModel> lampiran;

  const TugasPengajarModel({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.postedAt,
    this.dueDate,
    this.points = 100,
    this.acceptSubmissions = true,
    this.lampiran = const [],
  });

  factory TugasPengajarModel.fromJson(
    Map<String, dynamic> json, {
    String author = 'Pengajar',
  }) {
    final posted = (DateTime.tryParse(json['dibuat']?.toString() ?? '') ??
            DateTime.now())
        .toLocal();
    final rawLampiran = (json['lampiran'] as List<dynamic>? ?? const [])
        .map((e) => LampiranModel.fromRaw(e.toString()))
        .toList();

    return TugasPengajarModel(
      id: (json['id'] ?? '').toString(),
      title: json['judul'] as String? ?? '',
      description: json['deskripsi'] as String? ?? '',
      author: author,
      postedAt: posted,
      dueDate: posted.add(const Duration(days: 7)),
      points: 100,
      acceptSubmissions: true,
      lampiran: rawLampiran,
    );
  }

  // Salinan untuk hasil edit. Id, penulis, dan waktu posting tetap.
  // dueDate sengaja wajib ditulis supaya tenggat bisa dikosongkan.
  TugasPengajarModel withEdits({
    required String title,
    required String description,
    required DateTime? dueDate,
    required bool acceptSubmissions,
    required List<LampiranModel> lampiran,
  }) {
    return TugasPengajarModel(
      id: id,
      title: title,
      description: description,
      author: author,
      postedAt: postedAt,
      dueDate: dueDate,
      points: points,
      acceptSubmissions: acceptSubmissions,
      lampiran: lampiran,
    );
  }
}
