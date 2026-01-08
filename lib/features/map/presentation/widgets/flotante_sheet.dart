import 'package:flutter/material.dart';

typedef FlotanteSheetWrapperBuilder =
    Widget Function(BuildContext context, Widget child);

class FlotanteSheet extends StatefulWidget {
  // El contenido del sheet
  final Widget child;
  final Widget child2;

  /// Permite envolver el sheet con Providers manteniendo este widget genérico
  final FlotanteSheetWrapperBuilder? wrapperBuilder;
  
  // Propiedades de configuración de tamaño del sheet
  final double minChildSize;
  final double maxChildSize;
  final double? maxChildSize2;
  final double secondChildInitialSize;
  final List<double> snapPoints;
  final List<double>? snapPoints2;

  // Propiedades de animacion del sheet
  final double topRadius;
  final double collapsedBottomRadius;
  final double collapsedBottomPadding;
  final double collapsedSidePadding;

  final double innerBottomPaddingCollapsed;
  final double innerBottomPaddingExpanded;
  final double innerTopPadding;

  final Duration animationDuration;
  final Curve animationCurve;

  final bool dismissOnTapOutside;

  final VoidCallback? onCollapsed;
  final VoidCallback? onExpanded;

  const FlotanteSheet({
    super.key,
    required this.child,
    required this.child2,
    this.wrapperBuilder,
    this.minChildSize = .083,
    this.maxChildSize = .80,
    this.maxChildSize2,
    this.secondChildInitialSize = .55,
    this.snapPoints = const [.083, .30, .55, .80],
    this.snapPoints2,
    this.topRadius = 30,
    this.collapsedBottomRadius = 30,
    this.collapsedBottomPadding = 20,
    this.collapsedSidePadding = 16,
    this.innerBottomPaddingCollapsed = 10,
    this.innerBottomPaddingExpanded = 0,
    this.innerTopPadding = 5,
    this.animationDuration = const Duration(milliseconds: 120),
    this.animationCurve = Curves.easeOutCubic,
    this.dismissOnTapOutside = true,
    this.onCollapsed,
    this.onExpanded,
  });
  @override
  State<FlotanteSheet> createState() => FlotanteSheetState();
}

class FlotanteSheetState extends State<FlotanteSheet> {
  late final DraggableScrollableController _controller;
  double _innerBottomPadding = 10;
  bool _showSecondChild = false;

  bool get isShowingSecondChild => _showSecondChild;

  double get _secondChildInitialSize {
    final min = widget.minChildSize;
    final max = _currentMaxChildSize;
    return widget.secondChildInitialSize.clamp(min, max);
  }

  // Cambia entre los dos hijos
  void toggleChild() {
    setState(() {
      _showSecondChild = !_showSecondChild;
    });
  }

  // Muestra el primer hijo y ajusta la altura si es necesario
  void showFirstChild() {
    if (!_showSecondChild) return;
    setState(() {
      _showSecondChild = false;
      if (_controller.isAttached) {
        final max = _currentMaxChildSize;
        if (_controller.size > max) _controller.jumpTo(max);
      }
    });
  }

  // Muestra el segundo hijo y lo lleva a un tamaño inicial
  void showSecondChild() {
    if (_showSecondChild) return;
    setState(() {
      _showSecondChild = true;
    });

    // Al mostrar el segundo hijo, llevar el sheet a un tamaño inicial (ej: 0.5)
    // sin forzarlo al máximo.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !_showSecondChild || !_controller.isAttached) return;
      try {
        await _controller.animateTo(
          _secondChildInitialSize,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } catch (_) {}
    });
  }

  /// ==== Getters para tamaños de sheet ====
  double get _currentMaxChildSize => _showSecondChild
      ? (widget.maxChildSize2 ?? widget.maxChildSize)
      : widget.maxChildSize;

  List<double> get _currentSnapPoints => _showSecondChild
      ? (widget.snapPoints2 ?? widget.snapPoints)
      : widget.snapPoints;

  // Calcula el nivel de padding para ir agrandandoce en base al tamaño de arrastre
  double get _t {
    if (!_controller.isAttached) return 0.0;
    final s = _controller.size;
    final max = _currentMaxChildSize;
    final v = (s - widget.minChildSize) / (max - widget.minChildSize);
    return v.clamp(0.0, 1.0);
  }

  double _mix(double a, double b, double t) => a + (b - a) * t;

  bool get isExpanded {
    if (!_controller.isAttached) return false;
    return _controller.size > widget.minChildSize + 0.001;
  }

  bool _near(double a, double b, [double eps = 0.0005]) => (a - b).abs() < eps;

  void _syncInnerBottomPaddingAndCallbacks() {
    if (!_controller.isAttached) return;
    final size = _controller.size;
    final max = _currentMaxChildSize;

    if (_near(size, max)) {
      _innerBottomPadding = widget.innerBottomPaddingExpanded;
      widget.onExpanded?.call();
    } else if (_near(size, widget.minChildSize)) {
      _innerBottomPadding = widget.innerBottomPaddingCollapsed;
      widget.onCollapsed?.call();
    }
  }

  void _onSheetChange() {
    if (!mounted) return;
    setState(_syncInnerBottomPaddingAndCallbacks);
  }

  @override
  void initState() {
    super.initState();
    _innerBottomPadding = widget.innerBottomPaddingCollapsed;
    _controller = DraggableScrollableController()..addListener(_onSheetChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSheetChange);
    _controller.dispose();
    super.dispose();
  }

  //==== Manejo de altura desde Header ====
  void dragFromHeader(DragUpdateDetails details) {
    if (!_controller.isAttached) return;
    final height = MediaQuery.of(context).size.height;
    final next = (_controller.size - details.delta.dy / height).clamp(
      widget.minChildSize,
      _currentMaxChildSize,
    );
    _controller.jumpTo(next);
  }

  void endDragFromHeader(DragEndDetails details) {
    if (!_controller.isAttached) return;

    final v = details.primaryVelocity ?? 0.0;
    const double vThresh = 900;
    late double target;

    if (v > vThresh) {
      target = widget.minChildSize;
    } else if (v < -vThresh) {
      target = _currentMaxChildSize;
    } else {
      final cur = _controller.size;
      target = _currentSnapPoints.reduce(
        (a, b) => (cur - a).abs() < (cur - b).abs() ? a : b,
      );
    }

    final dist = (target - _controller.size).abs();
    final ms = (180 + 220 * dist).toInt();

    _controller.animateTo(
      target,
      duration: Duration(milliseconds: ms),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> collapseSheet() async {
    await _controller.animateTo(
      widget.minChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> expandSheet() async {
     await _controller.animateTo(
      _currentMaxChildSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    //==== Construcción del Sheet animado =====
    // Valores animados según el estado de expansión
    final double animatedBottom = _mix(widget.collapsedBottomPadding, 0, _t);
    final double animatedBorde = _mix(widget.collapsedBottomRadius, 0, _t);
    final double animatedAncho = _mix(widget.collapsedSidePadding, 0, _t);

    // Construcción del sheet
    final sheet = AnimatedPadding(
      duration: widget.animationDuration,
      curve: widget.animationCurve,
      padding: EdgeInsets.fromLTRB(animatedAncho, 0, animatedAncho, animatedBottom),
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: _showSecondChild ? _secondChildInitialSize : widget.minChildSize,
        minChildSize: widget.minChildSize,
        maxChildSize: _currentMaxChildSize,
        builder: (context, scrollController) {
          return AnimatedContainer(
            duration: widget.animationDuration,
            curve: widget.animationCurve,
            padding: EdgeInsets.only(
              top: widget.innerTopPadding,
              bottom: _innerBottomPadding,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(widget.topRadius),
                bottom: Radius.circular(animatedBorde),
              ),
              border: Border.all(width: 1.0, color: Colors.black54),
            ),
            child: PrimaryScrollController(
              controller: scrollController,
              child: _showSecondChild ? widget.child2 : widget.child,
            ),
          );
        },
      ),
    );

    final wrappedSheet = widget.wrapperBuilder?.call(context, sheet) ?? sheet;

    // Stack para detectar taps fuera del sheet y cerrarlo
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.dismissOnTapOutside && isExpanded)
          GestureDetector(
            onTap: () {
              collapseSheet();
            },
          ),
        wrappedSheet,
      ],
    );
  }
}
