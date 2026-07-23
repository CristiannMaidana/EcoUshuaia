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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            BarraAgarre(),
            
            SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(_addressOnly(address),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
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

  String _addressOnly(String value) {
    final firstPart = value.split(',').first.trim();
    return firstPart.isEmpty ? value : firstPart;
  }
}
