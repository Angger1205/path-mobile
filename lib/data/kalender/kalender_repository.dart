import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_mobile/data/kalender/agenda_model.dart';
import 'package:path_mobile/data/kelas/kelas_repository.dart';
import 'package:path_mobile/data/pengajar/pengajar_repository.dart';
import 'package:path_mobile/utils/date_format.dart';
import 'package:path_mobile/utils/http_client.dart';

class KalenderRepository extends ChangeNotifier {
  final HttpClient _client;
  final KelasRepository? kelasRepo;
  final PengajarRepository? pengajarRepo;

  KalenderRepository(this._client, {this.kelasRepo, this.pengajarRepo});

  final List<AgendaModel> _akademikEvents = [];

  void clear() {
    _akademikEvents.clear();
    notifyListeners();
  }

  /// Memuat kalender akademik dari `GET /kalender`.
  Future<void> fetchKalender() async {
    try {
      final res = await _client
          .get(_client.uri('/kalender'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return;

      final decoded = jsonDecode(res.body);
      final list = decoded is List ? decoded : const [];

      _akademikEvents.clear();
      for (final item in list) {
        if (item is! Map<String, dynamic>) continue;
        final title = item['nama_kegiatan'] as String? ?? '';
        final start = DateTime.tryParse(
          item['tanggal_mulai']?.toString() ?? '',
        );
        final end = DateTime.tryParse(
          item['tanggal_selesai']?.toString() ?? '',
        );
        if (title.isEmpty || start == null) continue;

        final timeLabel = end != null && end != start
            ? '${formatTanggal(start)} - ${formatTanggal(end)}'
            : 'Seharian';
        _akademikEvents.add(
          AgendaModel(
            date: start,
            heading: 'Kalender Akademik',
            title: title,
            time: timeLabel,
          ),
        );
      }
      notifyListeners();
    } catch (_) {}
  }

  List<AgendaModel> getAgenda() {
    final result = <AgendaModel>[..._akademikEvents];

    for (final tugas in kelasRepo?.tugasItems ?? const []) {
      result.add(
        AgendaModel(
          date: tugas.dueDate,
          heading: 'Tugas Kelas',
          title: tugas.title,
          time: formatJam(tugas.dueDate),
        ),
      );
    }

    for (final tugas in pengajarRepo?.allTugas ?? const []) {
      final due = tugas.dueDate ?? tugas.postedAt;
      result.add(
        AgendaModel(
          date: due,
          heading: 'Tugas Pengajar',
          title: tugas.title,
          time: formatJam(due),
        ),
      );
    }

    return result;
  }
}
