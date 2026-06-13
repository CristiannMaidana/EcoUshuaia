import 'package:flutter/material.dart';

class CustomNewNews extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final String infoText;
  final DateTime fecha;
  final Color color;

  const CustomNewNews({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.infoText,
    required this.fecha,
    required this.color,
  });

  // Method for the text of days left to the header
  String _daysLeftText(DateTime fecha) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(fecha.year, fecha.month, fecha.day);
    final days = target.difference(today).inDays;

    if (days <= 0) {
      return 'Today';
    }

    if (days == 1) {
      return 'Tomorrow';
    }

    return '$days days';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(width: 1.5, color: Colors.grey[400]!),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Icon(Icons.circle, size: 20, color: color),
              SizedBox(width: 20),
              // Texts and header
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(titulo, style: Theme.of(context).textTheme.titleMedium),
                        Text(_daysLeftText(fecha), style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    // Text
                    Text(subtitulo ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(infoText, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
