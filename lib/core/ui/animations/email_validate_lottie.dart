import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class EmailValidateLottie extends StatelessWidget {
  final double size;

  const EmailValidateLottie({
    super.key, 
    this.size = 24
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie/email_acept.json',
      width: size,
      height: size,
      repeat: false,
    );
  }
}
