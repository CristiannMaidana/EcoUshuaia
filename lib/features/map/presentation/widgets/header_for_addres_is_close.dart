import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:flutter/material.dart';

class HeaderForAddressIsClose extends StatelessWidget{
  final GestureDragUpdateCallback onVerticalDragUpdateFromFather;
  final GestureDragEndCallback onVerticalDragEndFromFather;
  final String address;
  final VoidCallback onPressedClose;

  const HeaderForAddressIsClose({
    super.key,
    required this.onVerticalDragUpdateFromFather,
    required this.onVerticalDragEndFromFather,
    required this.address,
    required this.onPressedClose,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: onVerticalDragUpdateFromFather,
      onVerticalDragEnd: onVerticalDragEndFromFather,
      child: Padding(
        padding: const EdgeInsets.only(left: 27, bottom: 6.3, right: 27),
        child: Column(
          children: [
            BarraAgarre(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(address),
                CircleIcon(
                  icon: Icons.close,
                  onPressed: onPressedClose,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
