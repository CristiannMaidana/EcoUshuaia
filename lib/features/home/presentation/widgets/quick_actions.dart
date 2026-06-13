import 'dart:async';
import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final FutureOr<void> Function()? goNearMe;
  final FutureOr<void> Function()? goMyZone;
  final FutureOr<void> Function()? goCalendar;
  final FutureOr<void> Function()? goWasteGuide;

  const QuickActions({
    super.key,
    this.goNearMe,
    this.goMyZone,
    this.goCalendar,
    this.goWasteGuide,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> actions = ['Cerca de mí', 'Mi zona', 'Calendario', 'Guía residuos'];
    final List<IconData> icons = [Icons.near_me_rounded, Icons.layers_rounded, Icons.calendar_month_rounded, Icons.menu_book_rounded];
    final List<FutureOr<void> Function()?> callbacks = [
      goNearMe,
      goMyZone,
      goCalendar,
      goWasteGuide,
    ];
    final List<Color> iconsColors = [
      const Color(0xFF3B82F6),
      const Color(0xFF2F9E74),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
    ];
    final List<Color> backgroundColors = [
      const Color(0xFFEAF2FF),
      const Color(0xFFE8F6EF),
      const Color(0xFFF2EBFF),
      const Color(0xFFFFF4DE),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Acciones rápidas', 
            style: Theme.of(context).textTheme.headlineSmall
          ),
          
          // Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                4, (index) => GestureDetector(
                  onTap: () async {
                    await callbacks[index]?.call();
                  },
                  // Button container
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    width: 106,
                    decoration: BoxDecoration(
                      color: backgroundColors[index],
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(width: 1.5, color: Colors.grey[400]!),
                    ),
                    // Button content
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: iconsColors[index],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(icons[index], color: Colors.white, size: 20),
                        ),
                        const SizedBox(height: 4),
                        // Text
                        Text(actions[index],
                          style: Theme.of(context).textTheme.bodySmall
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
