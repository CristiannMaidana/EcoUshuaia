import 'package:flutter/widgets.dart';
import 'package:eco_ushuaia/core/ui/animations/lottie_focus.dart';

class EmailLottie extends StatelessWidget {
  final FocusNode focusNode;
  final double size;

  const EmailLottie({Key? key, required this.focusNode, this.size = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LottieFocus(asset: 'assets/lottie/email.json', focusNode: focusNode, size: size);
  }
}
