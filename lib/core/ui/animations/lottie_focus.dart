import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieFocus extends StatefulWidget {
  final String asset;
  final FocusNode focusNode;
  final double size;
  final bool repeat;

  const LottieFocus({
    Key? key,
    required this.asset,
    required this.focusNode,
    this.size = 24,
    this.repeat = false,
  }) : super(key: key);

  @override
  State<LottieFocus> createState() => _LottieFocusState();
}

class _LottieFocusState extends State<LottieFocus> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this);
    widget.focusNode.addListener(_onFocus);
  }

  void _onFocus() {
    if (widget.focusNode.hasFocus) {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocus);
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
      repeat: widget.repeat,
      onLoaded: (comp) => _c.duration = comp.duration,
    );
  }
}
