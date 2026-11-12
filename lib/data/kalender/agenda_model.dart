/// Satu kegiatan di agenda: tugas yang tenggatnya dekat, atau event dari admin.
class AgendaModel {
  final DateTime date; // tanggal kegiatan (jamnya diabaikan)
  final String heading; // "Mapel 1" atau "Event"
  final String title; // "Tugas 1" atau "Pengajian SMK 2"
  final String time; // "01.00" atau "08.00 - 15.15"

  const AgendaModel({
    required this.date,
    required this.heading,
    required this.title,
    required this.time,
  });
}
