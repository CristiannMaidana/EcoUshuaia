import 'package:flutter/widgets.dart';

class BellIconButton extends StatelessWidget {
  final bool isActive;
  final double size;

  const BellIconButton({Key? key, this.isActive = false, this.size = 45}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(isActive
          ? 'assets/icons/settings/system/bell-2.png'
          : 'assets/icons/settings/system/bell.png'),
      width: size,
      height: size,
    );
  }
}
