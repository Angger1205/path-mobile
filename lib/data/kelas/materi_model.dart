import 'package:path_mobile/data/kelas/lampiran_model.dart';

class MateriModel {
  final int? id;
  final String title;
  final String author;
  final DateTime postedAt;
  final String description;
  final String fileName; // dipakai sisi murid (satu file)
  final String fileType;
  final List<LampiranModel> lampiran; // dipakai sisi pengajar (banyak lampiran)

  const MateriModel({
    this.id,
    required this.title,
    required this.author,
    required this.postedAt,
    required this.description,
    this.fileName = '',
    this.fileType = '',
    this.lampiran = const [],
  });

  factory MateriModel.fromJson(
    Map<String, dynamic> json, {
    String author = 'Pengajar',
  }) {
    final rawLampiran = (json['lampiran'] as List<dynamic>? ?? const [])
        .map((e) => LampiranModel.fromRaw(e.toString()))
        .toList();
    final firstFile = rawLampiran.isNotEmpty ? rawLampiran.first : null;
    final parsedDate = DateTime.tryParse(json['dibuat']?.toString() ?? '') ??
        DateTime.now();

    return MateriModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['judul'] as String? ?? '',
      author: author,
      postedAt: parsedDate.toLocal(),
      description: json['deskripsi'] as String? ?? '',
      fileName: firstFile?.name ?? '',
      fileType: firstFile?.detail ?? '',
      lampiran: rawLampiran,
    );
  }

  // Semua lampiran dalam satu daftar. Kalau materi lama (satu file),
  // dibungkus menjadi daftar berisi satu lampiran.
  List<LampiranModel> get semuaLampiran {
    if (lampiran.isNotEmpty) return lampiran;
    if (fileName.isEmpty) return const [];
    return [
      LampiranModel(type: LampiranType.file, name: fileName, detail: fileType),
    ];
  }

  MateriModel copyWith({
    int? id,
    String? title,
    String? description,
    List<LampiranModel>? lampiran,
  }) {
    return MateriModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author,
      postedAt: postedAt,
      description: description ?? this.description,
      fileName: fileName,
      fileType: fileType,
      lampiran: lampiran ?? this.lampiran,
    );
  }
}
