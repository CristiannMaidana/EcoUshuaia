import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/detail_button.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/detail_date.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/hole_scrim.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:eco_ushuaia/features/news/presentation/widgets/info_grind.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailNews extends StatefulWidget {
  final Calendarios? newCalendar;
  final VoidCallback onClose;

  const DetailNews({super.key, this.newCalendar, required this.onClose});

  @override
  State<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  final GlobalKey _anchorKey = GlobalKey();
  final GlobalKey _panelKey  = GlobalKey();
  OverlayEntry? _overlay;
  bool _showDateDetail = false;

  double _panelHeight = 0;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  //Funcion de acciones del boton
  void _toggleDateDetail(bool show) {
    if (show == _showDateDetail) return;
    _showDateDetail = show;
    if (show) {
      _showOverlayBelowAnchor();
    } else {
      _removeOverlay();
    }
    setState(() {});
  }
  
  //Funcion genera el panel y el bloqueo de pantalla exacto
  void _showOverlayBelowAnchor() {
    final anchorCtx = _anchorKey.currentContext;
    final overlayState = Overlay.of(context);
    // ignore: unnecessary_null_comparison
    if (anchorCtx == null || overlayState == null) return;

    final btnBox  = anchorCtx.findRenderObject() as RenderBox;
    final btnPos  = btnBox.localToGlobal(Offset.zero);
    final btnSize = btnBox.size;

    final screen = MediaQuery.of(context).size;
    const horizontalPadding = 20.0;
    final left   = horizontalPadding;
    final width  = screen.width - (horizontalPadding * 2);

    //Posicion del panel debajo del boton
    final panelTop = btnPos.dy + 30;

    //Restriccion del boton
    final buttonRect = Rect.fromLTWH(btnPos.dx+130, btnPos.dy, btnSize.width-130, btnSize.height);

    _overlay = OverlayEntry(
      builder: (_) {
        //Restriccion del panel
        final panelRect = Rect.fromLTWH(left, panelTop, width, _panelHeight);

        return Stack(children: [
          // Bloquea fondo fuera del rectángulo
          HoleScrim(
            holes: [buttonRect, panelRect],
            color: Colors.transparent,
            onTapOutside: () => _toggleDateDetail(false),
          ),
          // Panel
          Positioned(
            left: left,
            top: panelTop,
            width: width,
            child: DetailDate(date: widget.newCalendar!),
          ),
        ]);
      },
    );

    overlayState.insert(_overlay!);

    // Mide la altura real del panel y actualizamos el hueco
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _panelKey.currentContext;
      if (ctx == null) return;
      final box = ctx.findRenderObject() as RenderBox;
      final newH = box.size.height;
      if ((newH - _panelHeight).abs() > 0.5) {
        _panelHeight = newH;
        _overlay?.markNeedsBuild(); // rehace el Overlay con el hueco correcto
      }
    });
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
    _panelHeight = 0;
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.newCalendar;
    if (c == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Header
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleIcon(icon: Icons.map, onPressed: widget.onClose),
                  const SizedBox(width: 10),
                  CircleIcon(icon: Icons.add, onPressed: widget.onClose),
                  const SizedBox(width: 10),
                  CircleIcon(icon: Icons.close, onPressed: widget.onClose),
                ],
              ),
              //Texto Categorias
              Container(
                width: 150,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.message_sharp),
                    const SizedBox(width: 10),
                    Text("Categoria", style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              //Titulo Noticia
              Text(c.titulo, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
            ],
          ),
        ),
        //Datos fecha
        lineDivider(),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd/MM/yy – HH:mm').format(c.fechaHora), style: Theme.of(context).textTheme.labelMedium,),
                // Alterna entre "Detalle de fecha" y boton salir
                Container(
                  key: _anchorKey,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: ScaleTransition(scale: anim, child: child)),
                    child: _showDateDetail
                        ? CircleIcon(
                            key: const ValueKey('close-circle'),
                            icon: Icons.close,
                            onPressed: () => _toggleDateDetail(false),
                          )
                        : DetailButton(
                            key: const ValueKey('detail-button'),
                            onPressed: () => _toggleDateDetail(true),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //Datos residuo o nada
        lineDivider(),
        Container(
          color: Colors.white,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: InfoGrid(
              items: [
                InfoItem('Zona', 'Centro'),
                InfoItem('Categoría', 'Orgánicos'),
                InfoItem('Responsable', 'Higiene Urbana'),
                InfoItem('Contacto', '0800-XXX-1234'),
              ],
            ),
          ),
        ),
        //Texto de novedad
        lineDivider(),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(c.novedad, style: Theme.of(context).textTheme.labelMedium),
          ),
        ),
      ],
    );
  }
}
