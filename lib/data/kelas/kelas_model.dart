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
      id: json['id'],
      nama: json['nama'],
      tingkat: json['tingkat'],
      tahunAjaran: json['tahun_ajaran'],
      kodeKelas: json['kode_kelas'],
      pembuat: json['pembuat'],
      dibuat: json['dibuat'],
    );
  }
}
