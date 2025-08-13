import 'package:flutter/widgets.dart';
import 'package:eco_ushuaia/core/ui/animations/lottie_focus.dart';

class AvatarLottie extends StatelessWidget {
  final FocusNode focusNode;
  final double size;

  const AvatarLottie({Key? key, required this.focusNode, this.size = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LottieFocus(asset: 'assets/lottie/avatar.json', focusNode: focusNode, size: size);
  }
}
