import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieTapOnce extends StatefulWidget {
  final String asset;
  final double size;
  final VoidCallback? onTapEnd;

  const LottieTapOnce({
    Key? key,
    required this.asset,
    this.size = 36,
    this.onTapEnd,
  }) : super(key: key);

  @override
  State<LottieTapOnce> createState() => _LottieTapOnceState();
}

class _LottieTapOnceState extends State<LottieTapOnce> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _play() async {
    _c.forward(from: 0);
    await _c.forward(from: 0);
    widget.onTapEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _play,
      child: Lottie.asset(
        widget.asset,
        controller: _c,
        width: widget.size,
        height: widget.size,
        repeat: false,
        onLoaded: (comp) => _c.duration = comp.duration,
      ),
    );
  }
}
