import 'package:flutter/material.dart';
import 'package:path_mobile/data/kalender/agenda_model.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class AgendaRow extends StatelessWidget {
  final DateTime date;
  final List<AgendaModel> items;
  final bool isToday;

  const AgendaRow({
    super.key,
    required this.date,
    required this.items,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildDateLabel(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  for (final item in items) ...[
                    _AgendaCard(item: item),
                    const SizedBox(width: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateLabel() {
    if (!isToday) {
      return Text(
        '${date.day}',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.text,
        ),
      );
    }

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.color1,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${date.day}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AgendaCard extends StatelessWidget {
  final AgendaModel item;

  const _AgendaCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      color: AppColors.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      item.heading,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Spacer(),
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
