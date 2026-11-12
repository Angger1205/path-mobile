import 'package:path_mobile/data/kelas/lampiran_model.dart';

enum TugasStatus { ditugaskan, dikumpulkan, terlambat, ditandaiSelesai }

// Tulisan yang tampil di layar untuk tiap status
extension TugasStatusLabel on TugasStatus {
  String get label => switch (this) {
    TugasStatus.ditugaskan => 'Ditugaskan',
    TugasStatus.dikumpulkan => 'Dikumpulkan',
    TugasStatus.terlambat => 'Terlambat',
    TugasStatus.ditandaiSelesai => 'Ditandai Sebagai Selesai',
  };
}

class TugasModel {
  final String id; // pengenal unik, untuk mencari tugas ini di papan
  final String title; // "Praktikum Laravel"
  final String author; // "Joko Sutoyo"
  final DateTime postedAt; // kapan tugas diberikan
  final DateTime dueDate; // batas pengumpulan (tenggat)
  final int points; // 100
  final String description;
  final TugasStatus status;
  final List<LampiranModel> lampiran; // lampiran yang sudah diserahkan

  const TugasModel({
    required this.id,
    required this.title,
    required this.author,
    required this.postedAt,
    required this.dueDate,
    required this.points,
    required this.description,
    required this.status,
    this.lampiran = const [],
  });

  factory TugasModel.fromJson(
    Map<String, dynamic> json, {
    String author = 'Pengajar',
  }) {
    final posted = (DateTime.tryParse(json['dibuat']?.toString() ?? '') ??
            DateTime.now())
        .toLocal();
    return TugasModel(
      id: (json['id'] ?? '').toString(),
      title: json['judul'] as String? ?? '',
      author: author,
      postedAt: posted,
      dueDate: posted.add(const Duration(days: 7)),
      points: 100,
      description: json['deskripsi'] as String? ?? '',
      status: TugasStatus.ditugaskan,
      lampiran: const [],
    );
  }

  // Membuat salinan tugas ini dengan sebagian isi diganti.
  TugasModel copyWith({TugasStatus? status, List<LampiranModel>? lampiran}) {
    return TugasModel(
      id: id,
      title: title,
      author: author,
      postedAt: postedAt,
      dueDate: dueDate,
      points: points,
      description: description,
      status: status ?? this.status,
      lampiran: lampiran ?? this.lampiran,
    );
  }

  // "Missing" = batas waktu sudah lewat dan tugas belum dikumpulkan
  bool get isMissing =>
      status == TugasStatus.ditugaskan && dueDate.isBefore(DateTime.now());
}
