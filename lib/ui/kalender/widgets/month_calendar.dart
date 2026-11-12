import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/utils/date_format.dart';

class MonthCalendar extends StatelessWidget {
  final DateTime month;
  final DateTime today;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const MonthCalendar({
    super.key,
    required this.month,
    required this.today,
    required this.onPrev,
    required this.onNext,
  });

  static const _weekdays = ['S', 'S', 'R', 'K', 'J', 'S', 'M'];
  static const _line = Divider(height: 1, thickness: 1, color: Colors.black12);

  @override
  Widget build(BuildContext context) {
    final leading = month.weekday - 1;
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final rows = ((leading + daysInMonth) / 7).ceil();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _arrow(Icons.chevron_left, 'Bulan sebelumnya', onPrev),
            SizedBox(
              width: 130,
              child: Text(
                formatBulanTahun(month),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ),
            _arrow(Icons.chevron_right, 'Bulan berikutnya', onNext),
          ],
        ),
        _line,
        SizedBox(
          height: 36,
          child: Row(
            children: [
              for (final d in _weekdays)
                Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        _line,
        for (var r = 0; r < rows; r++)
          Row(
            children: [
              for (var c = 0; c < 7; c++)
                Expanded(child: _buildCell(r * 7 + c, leading)),
            ],
          ),
      ],
    );
  }

  Widget _buildCell(int index, int leading) {
    final date = DateTime(month.year, month.month, 1 - leading + index);
    final inMonth = date.month == month.month;

    return _DayCell(
      date: date,
      inMonth: inMonth,
      isToday: inMonth && DateUtils.isSameDay(date, today),
    );
  }

  Widget _arrow(IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20, color: AppColors.text),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool inMonth;
  final bool isToday;

  const _DayCell({
    required this.date,
    required this.inMonth,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final isSunday = date.weekday == DateTime.sunday;

    Color color;
    if (inMonth) {
      color = isSunday ? AppColors.error : AppColors.text;
    } else {
      color = isSunday
          ? AppColors.error.withValues(alpha: 0.35)
          : AppColors.secondaryText.withValues(alpha: 0.45);
    }

    return SizedBox(
      height: 44,
      child: Center(
        child: DecoratedBox(
          decoration: isToday
              ? const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.color1,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                )
              : const BoxDecoration(),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isToday ? Colors.white : color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
