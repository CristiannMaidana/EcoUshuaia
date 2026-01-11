import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/carta_detalles_recientes.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/slider_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetAddContainer extends StatefulWidget {
  final double lon;
  final double lat;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final VoidCallback? onClosed;
  final ValueChanged<Contenedor> add;

  const SheetAddContainer({
    super.key,
    required this.lon,
    required this.lat,
    this.initialChildSize = 0.0,
    this.minChildSize = 0.0,
    this.maxChildSize = .7,
    this.onClosed,
    required this.add,
  });

  @override
  State<SheetAddContainer> createState() => SheetAddContainerState();
}

class SheetAddContainerState extends State<SheetAddContainer> {
  late final DraggableScrollableController _controller;
  bool _isOpen = false;
  bool _closedNotified = true;
  static const double _headerExtent = 60;

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

    final openNow = _controller.size > widget.minChildSize + eps;
    if (openNow == _isOpen) return;

    setState(() => _isOpen = openNow);
    if (openNow) {
      _closedNotified = false;
    } else {
      _notifyClosed();
    }
  }

  void _notifyClosed() {
    if (_closedNotified) return;
    _closedNotified = true;
    widget.onClosed?.call();
  }

  //=== Manejo del arrastre del Header ===
  void dragFromHeader(DragUpdateDetails details) {
    if (!_controller.isAttached) return;
    final height = MediaQuery.of(context).size.height;
    final next = (_controller.size - details.delta.dy / height).clamp(
      widget.minChildSize,
      widget.maxChildSize,
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
      target = widget.maxChildSize;
    } else {
      final mid = (widget.minChildSize + widget.maxChildSize) / 2;
      target =
          _controller.size < mid ? widget.minChildSize : widget.maxChildSize;
    }

    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  //=== Cierre y abrir sheet ===
  Future<void> expand() async {
    if (!mounted) return;
    _closedNotified = false;
    await _animateTo(widget.maxChildSize);
  }

  Future<void> collapse() async {
    if (!mounted) return;
    await _animateTo(widget.minChildSize);
  }

  // Helper para las animacion de collapse y expand
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: DraggableScrollableSheet(
            controller: _controller,
            initialChildSize: widget.initialChildSize,
            minChildSize: widget.minChildSize,
            maxChildSize: widget.maxChildSize,
            builder: (context, scrollController) {
              final vmContenedores = context.watch<ContenedorViewModel>();
              final contenedoresCercanos = vmContenedores.contenedorCercanos;

              return Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: _headerExtent),
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            // Slider para modificar radio de contenedores
                            SliverToBoxAdapter(
                              child: SliderCustom(
                                lon: widget.lon,
                                lat: widget.lat,
                              ),
                            ),
                            
                            //==== Manejo de estados de conexion del provider ====
                            // Representacion de la pantalla si esta cargando
                            if (vmContenedores.loading)
                              const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(child: CircularProgressIndicator()),
                              )
                            // Representación de la pantalla si ocurrio un error
                            else if (vmContenedores.error != null)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(child: Text(vmContenedores.error!)),
                              )
                            // Representación del contenido
                            else
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: CartaDetallesRecientes(
                                        contenedor: contenedoresCercanos[index],
                                        ir: widget.add,
                                      ),
                                    );
                                  },
                                  childCount: contenedoresCercanos.length,
                                ),
                              ),
                            const SliverToBoxAdapter(
                                child: SizedBox(height: 24)
                            ),
                          ],
                        ),
                      ),

                      // Header inamovible
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: dragFromHeader,
                        onVerticalDragEnd: endDragFromHeader,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Seleccionar parada',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              CircleIcon(
                                icon: Icons.close,
                                onPressed: collapse,
                              ),
                            ],
                          ),
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
