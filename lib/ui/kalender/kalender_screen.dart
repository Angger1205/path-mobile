import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';
import 'package:path_mobile/ui/kalender/kalender_controller.dart';
import 'package:path_mobile/ui/kalender/widgets/agenda_row.dart';
import 'package:path_mobile/ui/kalender/widgets/month_calendar.dart';

class KalenderScreen extends StatelessWidget {
  final KalenderController controller;

  const KalenderScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      breadcrumb: const ['Kalender'],
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final days = controller.days;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Text(
                  'Kalender',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MonthCalendar(
                  month: controller.shownMonth,
                  today: controller.today,
                  onPrev: () => controller.changeMonth(-1),
                  onNext: () => controller.changeMonth(1),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Text(
                  'Agenda',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              Expanded(
                child: days.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada agenda',
                          style: TextStyle(color: AppColors.secondaryText),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 0, 24),
                        itemCount: days.length,
                        itemBuilder: (context, i) {
                          final day = days[i];
                          return AgendaRow(
                            date: day.key,
                            items: day.value,
                            isToday: DateUtils.isSameDay(
                              day.key,
                              controller.today,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
