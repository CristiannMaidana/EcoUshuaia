import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:flutter/material.dart';

class DetailDate extends StatelessWidget {
  const DetailDate({super.key});

  @override
  Widget build(BuildContext context) {
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
              _row(context, "Dia", "Mié 21 oct 2025"),
              lineDivider(),
              _row(context, "Hora", "10:00"),
              lineDivider(),
              _row(context, "Duracion", "90 min"),
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
