const _namaBulan = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

/// 2026-08-09 menjadi "9 Agustus 2026"
String formatTanggal(DateTime date) {
  return '${date.day} ${_namaBulan[date.month - 1]} ${date.year}';
}

/// jam 13:00 menjadi "13.00"
String formatJam(DateTime date) {
  final jam = date.hour.toString().padLeft(2, '0');
  final menit = date.minute.toString().padLeft(2, '0');
  return '$jam.$menit';
}

/// 2026-09-01 menjadi "September 2026"
String formatBulanTahun(DateTime date) {
  return '${_namaBulan[date.month - 1]} ${date.year}';
}
