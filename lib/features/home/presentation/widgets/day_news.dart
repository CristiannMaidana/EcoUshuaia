import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/card_touch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayNews extends StatelessWidget {
  final List<Calendarios>? news;

  const DayNews({
    super.key,
    required this.news,
  });

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) {
      return '${minutes}m';
    }

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final items = news ?? const <Calendarios>[];

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen del dia', style: Theme.of(context).textTheme.headlineSmall),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items.isEmpty
              //Content if dont have news
                  ? [
                      Container(
                        width: 400,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          border: Border.all(width: 1.5, color: Colors.grey[400]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Hoy', style: Theme.of(context).textTheme.titleMedium),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: camarone50,
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(width: 1.5, color: Colors.grey[400]!),
                                  ),
                                  child: Text('Sin novedades', style: Theme.of(context).textTheme.titleMedium),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text('No hay avisos, cambios ni eventos programados para hoy en tu zona.',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ]
              // Content for the news of the day
                  : List.generate(items.length, (index) {
                final item = items[index];

                return CardTouche(
                  title: item.titulo,
                  infoText: '${DateFormat('dd/MM/yyyy').format(item.fecha)} · ${_formatDuration(item.hora)} · ${_formatDuration(item.duracion)}',
                  subtitle: item.subtitulo ?? '',
                  onTap: () {
                    // Path to go to the news selected of the day
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
