import 'package:eco_ushuaia/core/ui/layout/spacing.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:flutter/material.dart';

class DetailNews extends StatelessWidget{
  final Calendarios? newCalendar;

  const DetailNews({super.key, this.newCalendar});

  @override
  Widget build(BuildContext context) {
     final c = newCalendar;
    if (c == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(c.titulo, style: Theme.of(context).textTheme.headlineSmall),
        espacioVerticalMediano,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Text('Fecha', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(width: 8),
            // si tienes c.fechaHora:
            // Text(DateFormat('dd/MM/yy – HH:mm').format(c.fechaHora)),
          ],
        ),espacioVerticalMediano,
        Text(c.novedad, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}