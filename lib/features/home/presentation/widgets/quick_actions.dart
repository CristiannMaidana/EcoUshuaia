import 'dart:async';
import 'package:eco_ushuaia/features/home/presentation/widgets/button_with_icon_and_text.dart';
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
    final List<String> actions = ['Cerca de mí', 'Mi zona', 'Calendario', 'Guía residuos', 'Favoritos'];
    final List<IconData> icons = [Icons.near_me_rounded, Icons.layers_rounded, Icons.calendar_month_rounded, Icons.menu_book_rounded, Icons.favorite];
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
      const Color(0xFFE83E8C),
    ];
    final List<Color> backgroundColors = [
      const Color(0xFFEAF2FF),
      const Color(0xFFE8F6EF),
      const Color(0xFFF2EBFF),
      const Color(0xFFFFF4DE),
      const Color(0xFFFDECF4),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                5, (index) => GestureDetector(
                  onTap: () async {
                    await callbacks[index]?.call();
                  },
                  child: ButtonWithIconAndText(
                    label: actions[index],
                    icon: icons[index],
                    iconColor: iconsColors[index],
                    backgroundColor: backgroundColors[index],
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
