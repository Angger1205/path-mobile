import 'package:path_mobile/ui/core/app_assets.dart';

class KelasModel {
  final int id;
  final String nama;
  final int tingkat;
  final String tahunAjaran;
  final String kodeKelas;
  final int pembuat;
  final String dibuat;

  KelasModel({
    required this.id,
    required this.nama,
    required this.tingkat,
    required this.tahunAjaran,
    required this.kodeKelas,
    required this.pembuat,
    required this.dibuat,
  });

  factory KelasModel.fromJson(Map<String, dynamic> json) {
    return KelasModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nama: json['nama'] as String? ?? '',
      tingkat: (json['tingkat'] as num?)?.toInt() ?? 10,
      tahunAjaran: json['tahun_ajaran'] as String? ?? '',
      kodeKelas: json['kode_kelas'] as String? ?? '',
      pembuat: (json['pengampu'] as num?)?.toInt() ??
          (json['pembuat'] as num?)?.toInt() ??
          0,
      dibuat: json['dibuat']?.toString() ?? '',
    );
  }

  ClassModel toClassModel({String? teacher, int index = 0}) {
    final roman = switch (tingkat) {
      10 => 'X',
      11 => 'XI',
      12 => 'XII',
      _ => '$tingkat',
    };
    return ClassModel(
      id: id,
      title: nama,
      grade: 'Kelas $roman',
      teacher: teacher,
      imagePath: AppAssets.covers[index % AppAssets.covers.length],
      code: kodeKelas,
    );
  }

  static int parseTingkat(String grade) {
    final clean = grade.replaceFirst('Kelas ', '').trim().toUpperCase();
    return switch (clean) {
      'X' || '10' => 10,
      'XI' || '11' => 11,
      'XII' || '12' => 12,
      _ => int.tryParse(clean) ?? 10,
    };
  }
}

class ClassModel {
  final int? id;
  final String title; // "Mapel 1"
  final String grade; // "Kelas X"
  final String? teacher; // boleh kosong (tab Pengajar tidak menampilkan guru)
  final String? imagePath; // boleh kosong, nanti diisi path asset
  final String? code; // kode kelas dari backend

  const ClassModel({
    this.id,
    required this.title,
    required this.grade,
    this.teacher,
    this.imagePath,
    this.code,
  });

  String get inviteLink => 'https://path.app/join/$code';
}
