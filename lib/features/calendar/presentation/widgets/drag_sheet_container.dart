import 'package:eco_ushuaia/core/theme/gradiente.dart';
import 'package:flutter/material.dart';

class DragSheetContainer extends StatefulWidget {
  final double minHeight;
  final double maxHeight;
  final Duration duration;
  final Curve curve;
  final Widget child;
  final bool outsideDismissible;
  final Color scrimColor;

  const DragSheetContainer({
    super.key,
    this.minHeight = 0,
    this.maxHeight = 900,
    this.duration = const Duration(milliseconds: 450),
    this.curve = Curves.easeOutCubic,
    this.child = const SizedBox.shrink(),
    this.outsideDismissible = true,
    this.scrimColor = Colors.transparent,
  });

  @override
  DragSheetContainerState createState() => DragSheetContainerState();
}

class DragSheetContainerState extends State<DragSheetContainer> {
  late final DraggableScrollableController _ctrl;
  double _minFrac = 0.1;
  double _maxFrac = 0.3;

  bool _barrierActive = false;

  ScrollController? _localController;
  bool _showJumpTop = false;

  @override
  void initState() {
    super.initState();
    _ctrl = DraggableScrollableController()
      ..addListener(() {
        final isActive = _ctrl.size > (_minFrac + 0.001);
        if (isActive != _barrierActive) {
          setState(() => _barrierActive = isActive);
        }
      });
  }

  @override
  void dispose() {
    _localController?.removeListener(_onScrollChange);
    _ctrl.dispose();
    super.dispose();
  }

  void _attachScrollController(ScrollController sc) {
    if (_localController == sc) return;
    _localController?.removeListener(_onScrollChange);
    _localController = sc;
    _localController!.addListener(_onScrollChange);
  }

  void _onScrollChange() {
    if (_localController == null) return;
    final show = _localController!.offset > 100;
    if (show != _showJumpTop) setState(() => _showJumpTop = show);
  }

  Future<void> _jumpToTop() async {
    if (_localController == null) return;
    try {
      await _localController!.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (_) {}
  }

  Future<void> collapse() async {
    await _jumpToTop();
    try {
      await _ctrl.animateTo(
        _minFrac,
        duration: widget.duration,
        curve: widget.curve,
      );
    } catch (_) {}
  }

  void expand() {
    _ctrl.animateTo(
      _maxFrac,
      duration: widget.duration,
      curve: widget.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    _minFrac = (widget.minHeight / h).clamp(0.0, 1.0);
    _maxFrac = (widget.maxHeight / h).clamp(_minFrac + 0.01, 1.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.outsideDismissible)
          IgnorePointer(
            ignoring: !_barrierActive,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () { collapse(); },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 450),
                color: _barrierActive ? widget.scrimColor : Colors.transparent,
              ),
            ),
          ),

        Align(
          alignment: Alignment.bottomCenter,
          child: DraggableScrollableSheet(
            controller: _ctrl,
            initialChildSize: 0,
            minChildSize: 0,
            maxChildSize: .9,
            snap: true,
            builder: (context, scrollController) {
              _attachScrollController(scrollController);

              return GestureDetector(
                onTap: () { expand(); },
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: Stack(
                    children: [
                      const Positioned.fill(child: Gradiente()),
                      Material(
                        elevation: 12,
                        color: Colors.transparent,
                        child: ListView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            const SizedBox(height: 18),
                            widget.child,
                          ],
                        ),
                      ),

                      //Boton para subir arriba
                      if (_showJumpTop)
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: FloatingActionButton(
                            backgroundColor: Colors.black.withOpacity(0.8),
                            mini: true,
                            onPressed: () { _jumpToTop(); },
                            child: const Icon(Icons.keyboard_arrow_up,
                                color: Colors.white, size: 32),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
