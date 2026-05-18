import 'package:flutter/widgets.dart';
import 'package:eco_ushuaia/core/ui/animations/lottie_toggle.dart';

class EyePasswordLottie extends StatelessWidget {
  final bool isClosed;
  final double size;
  final VoidCallback onTap;

  const EyePasswordLottie({
    super.key,
    required this.isClosed,
    required this.onTap,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LottieToggle(
        asset: 'assets/lottie/eye_password.json',
        isOn: isClosed,
        size: size,
      ),
    );
  }
}
