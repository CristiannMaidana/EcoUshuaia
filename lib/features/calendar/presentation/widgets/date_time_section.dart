import 'package:flutter/material.dart';

class DateTimeSection extends StatelessWidget {
  final VoidCallback onToggleFecha;
  final bool dateOpen;

  final bool hourEnabled;
  final ValueChanged<bool> onHourChanged;
  final String hourText;

  const DateTimeSection({
    required this.onToggleFecha,
    required this.dateOpen,
    required this.hourEnabled,
    required this.onHourChanged,
    required this.hourText,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(32);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: radius,
      ),
      child: Column(
        children: [
          // Fecha
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              onTap: onToggleFecha,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.calendar_month, size: 28),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Fecha", style: Theme.of(context).textTheme.labelMedium),
                        Text("hoy", style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Panel expandible de calendario
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            height: dateOpen ? 280 : 0,
            child: dateOpen
                ? const ColoredBox(color: Colors.white)
                : const SizedBox.shrink(),
          ),

          const Divider(height: 1, thickness: 1, color: Colors.black26),

          // Hora
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.schedule, size: 28),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hora", style: Theme.of(context).textTheme.labelMedium),
                      Text(
                        hourText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: hourEnabled ? 
                              Colors.red :
                              Colors.red.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: hourEnabled,
                  onChanged: onHourChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
