import 'package:path_mobile/data/kalender/agenda_model.dart';
import 'package:path_mobile/data/kelas/kelas_repository.dart';
import 'package:path_mobile/data/pengajar/pengajar_repository.dart';
import 'package:path_mobile/utils/date_format.dart';
import 'package:path_mobile/utils/http_client.dart';

class KalenderRepository {
  final HttpClient _client;
  final KelasRepository? kelasRepo;
  final PengajarRepository? pengajarRepo;

  KalenderRepository(this._client, {this.kelasRepo, this.pengajarRepo});

  HttpClient get client => _client;

  List<AgendaModel> getAgenda() {
    final result = <AgendaModel>[];

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
