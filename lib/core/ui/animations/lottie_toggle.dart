import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieToggle extends StatefulWidget {
  final String asset;
  final bool isOn;
  final double size;

  const LottieToggle({
    Key? key,
    required this.asset,
    required this.isOn,
    this.size = 24,
  }) : super(key: key);

  @override
  State<LottieToggle> createState() => _LottieToggleState();
}

class _LottieToggleState extends State<LottieToggle> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _c.value = widget.isOn ? 1 : 0;
    });
  }

  @override
  void didUpdateWidget(covariant LottieToggle old) {
    super.didUpdateWidget(old);
    if (old.isOn != widget.isOn) {
      if (widget.isOn) {
        _c.forward(from: 0);
      } else {
        _c.reverse(from: 1);
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.asset,
      controller: _c,
      width: widget.size,
      height: widget.size,
      repeat: false,
      onLoaded: (comp) => _c.duration = comp.duration,
    );
  }
}
