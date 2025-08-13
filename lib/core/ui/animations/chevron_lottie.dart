import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class ChevronLottie extends StatelessWidget {
  final double size;
  const ChevronLottie({Key? key, this.size = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie/chevron_right_in_reveal.json',
      width: size,
      height: size,
      repeat: false,
    );
  }
}
