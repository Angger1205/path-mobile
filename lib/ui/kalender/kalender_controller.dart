import 'package:flutter/material.dart';
import 'package:path_mobile/data/kalender/agenda_model.dart';
import 'package:path_mobile/data/kalender/kalender_repository.dart';

class KalenderController extends ChangeNotifier {
  final KalenderRepository _repo;

  late final DateTime today;
  late DateTime shownMonth;
  List<MapEntry<DateTime, List<AgendaModel>>> days = const [];

  KalenderController(this._repo) {
    final now = DateTime.now();
    today = DateTime(now.year, now.month, now.day);
    shownMonth = DateTime(now.year, now.month);
    _refresh();
    _repo.addListener(_refresh);
    _repo.kelasRepo?.addListener(_refresh);
    _repo.pengajarRepo?.addListener(_refresh);
  }

  Future<void> fetchKalender() => _repo.fetchKalender();

  void _refresh() {
    days = _groupByDate(_repo.getAgenda());
    notifyListeners();
  }

  List<MapEntry<DateTime, List<AgendaModel>>> _groupByDate(
    List<AgendaModel> items,
  ) {
    final limit = DateTime(today.year, today.month + 3, today.day);
    final map = <DateTime, List<AgendaModel>>{};

    for (final item in items) {
      final day = DateUtils.dateOnly(item.date);
      if (day.isBefore(today) || day.isAfter(limit)) continue;
      map.putIfAbsent(day, () => []).add(item);
    }

    final entries = map.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }

  void changeMonth(int delta) {
    shownMonth = DateTime(shownMonth.year, shownMonth.month + delta);
    notifyListeners();
  }

  @override
  void dispose() {
    _repo.removeListener(_refresh);
    _repo.kelasRepo?.removeListener(_refresh);
    _repo.pengajarRepo?.removeListener(_refresh);
    super.dispose();
  }
}
