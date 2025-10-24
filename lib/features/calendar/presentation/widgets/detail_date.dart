import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailDate extends StatelessWidget {
  final Calendarios date;
  const DetailDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final String dia = toBeginningOfSentenceCase(DateFormat('EEE d MMM y').format(date.fechaHora));

    final String hora = DateFormat('HH:mm').format(date.fechaHora);

    final String duracion = '90 min';

    return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18), bottom: Radius.circular(18)),
          ),
          child: Column(
            children: [
              _row(context, "Dia", "$dia"),
              lineDivider(),
              _row(context, "Hora", "$hora"),
              lineDivider(),
              _row(context, "Duracion", "$duracion"),
            ],
          ),
        ),
    );
  }

  Widget _row(BuildContext context, String l, String r) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: Theme.of(context).textTheme.labelMedium),
            Text(r, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      );
}
