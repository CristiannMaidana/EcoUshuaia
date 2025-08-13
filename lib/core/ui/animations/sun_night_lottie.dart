import 'package:flutter/widgets.dart';
import 'package:eco_ushuaia/core/ui/animations/lottie_toggle.dart';

class SunNightLottie extends StatelessWidget {
  final bool isNight;
  final double size;

  const SunNightLottie({Key? key, required this.isNight, this.size = 36}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LottieToggle(
      asset: 'assets/lottie/sun_night.json',
      isOn: isNight,
      size: size,
    );
  }
}
