// Urutan enum ini sama dengan urutan grup di layar
enum PengumpulanStatus { diserahkan, ditugaskan, dinilai }

extension PengumpulanStatusLabel on PengumpulanStatus {
  String get label => switch (this) {
    PengumpulanStatus.diserahkan => 'Diserahkan',
    PengumpulanStatus.ditugaskan => 'Ditugaskan',
    PengumpulanStatus.dinilai => 'Dinilai',
  };
}

/// Satu baris siswa di halaman Cek Jawaban.
class PengumpulanModel {
  final String studentName;
  final String? fileName; // kosong kalau siswa belum mengumpulkan
  final PengumpulanStatus status;
  final int? score; // kosong = belum dinilai

  const PengumpulanModel({
    required this.studentName,
    this.fileName,
    required this.status,
    this.score,
  });

  factory PengumpulanModel.fromJson(Map<String, dynamic> json) {
    final lampiran = (json['lampiran'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    final firstFile = lampiran.isNotEmpty
        ? lampiran.first.split('/').last
        : null;
    return PengumpulanModel(
      studentName: json['nama_pengguna'] as String? ?? 'Siswa',
      fileName: firstFile,
      status: PengumpulanStatus.diserahkan,
    );
  }

  PengumpulanModel copyWith({PengumpulanStatus? status, int? score}) {
    return PengumpulanModel(
      studentName: studentName,
      fileName: fileName,
      status: status ?? this.status,
      score: score ?? this.score,
    );
  }
}
