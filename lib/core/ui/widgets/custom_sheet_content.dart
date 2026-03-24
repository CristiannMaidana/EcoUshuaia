import 'package:flutter/material.dart';

class CustomSheetContent extends StatefulWidget {
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool snap;
  final List<double>? snapSizes;
  final VoidCallback? onClosed;
  final Widget child;
  final EdgeInsetsGeometry contentPadding;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder? border;

  const CustomSheetContent({
    super.key,
    this.initialChildSize = 0.0,
    this.minChildSize = 0.0,
    this.maxChildSize = 0.6,
    this.snap = true,
    this.snapSizes,
    this.onClosed,
    this.child = const SizedBox.shrink(),
    this.contentPadding = const EdgeInsets.fromLTRB(20, 12, 20, 24),
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(34)),
    this.border,
  });

  @override
  State<CustomSheetContent> createState() => CustomSheetContentState();
}

class CustomSheetContentState extends State<CustomSheetContent> {
  late final DraggableScrollableController _controller;
  bool _closedNotified = true;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController()..addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!_controller.isAttached) return;
    const eps = 0.001;
    if (_controller.size <= widget.minChildSize + eps) {
      _notifyClosed();
    } else {
      _closedNotified = false;
    }
  }

  void _notifyClosed() {
    if (_closedNotified) return;
    _closedNotified = true;
    widget.onClosed?.call();
  }

  Future<void> expand() async {
    if (!mounted) return;
    _closedNotified = false;
    await _animateTo(widget.maxChildSize);
  }

  Future<void> collapse() async {
    if (!mounted) return;
    await _animateTo(widget.minChildSize);
  }

  Future<void> _animateTo(double size) async {
    if (!_controller.isAttached) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_controller.isAttached) return;
        _controller.animateTo(
          size,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
        );
      });
      return;
    }

    try {
      await _controller.animateTo(
        size,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      snap: widget.snap,
      snapSizes: widget.snapSizes,
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: widget.borderRadius,
              border: widget.border,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: widget.contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 48,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        widget.child,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
