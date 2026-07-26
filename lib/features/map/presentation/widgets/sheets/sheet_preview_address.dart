import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/custom_card_option_settings.dart';
import 'package:flutter/material.dart';

class SheetPreviewAddress extends StatefulWidget {
  final double initialSheetSize;
  final double minSheetSize;
  final double maxSheetSize;

  final Future<void> Function() onCloseForSearchAddress;
  final Future<void> Function() onCloseForNavButtonExpandSheet;
  final Future<void> Function(double lat, double lon)? searchDirection;
  final Future<void> Function()? openDetailDirection;
  final Future<void> Function()? generateRouteWithCar;

  const SheetPreviewAddress ({
    super.key,
    this.initialSheetSize = 0.00,
    this.minSheetSize = 0.00,
    this.maxSheetSize = 0.50,

    required this.onCloseForSearchAddress,
    required this.onCloseForNavButtonExpandSheet,
    required this.generateRouteWithCar,
    required this.openDetailDirection,
    required this.searchDirection,
  });

  @override
  State<SheetPreviewAddress> createState () => SheetPreviewAddressState(); 
}

class SheetPreviewAddressState extends State<SheetPreviewAddress> {
  late final DraggableScrollableController draggableControllerOfPreviewAddress;
  bool _isSheetOpen = false;

  double get _snapMidpoint => (widget.initialSheetSize + widget.maxSheetSize) / 2;
  
  late double _latitud;
  late double _longitud;

 // Functionality for opacity of sheet
  double get _contentOpacity {
    if (!draggableControllerOfPreviewAddress.isAttached) return 0.0;

    final currentSize = draggableControllerOfPreviewAddress.size;
    
    // La animación de aparición empieza después de este punto
    final fadeStart = widget.initialSheetSize + 0.17;

    // Evita división por 0 o rangos inválidos
    if (widget.maxSheetSize <= fadeStart) return 1.0;
    
    final opacity = (currentSize - fadeStart) / (widget.maxSheetSize - fadeStart);

    return opacity.clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    draggableControllerOfPreviewAddress = DraggableScrollableController()
    ..addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    draggableControllerOfPreviewAddress.removeListener(_onSheetChanged);
    draggableControllerOfPreviewAddress.dispose();
    super.dispose();
  }

  void _onSheetChanged() {
    if (!mounted) return;
    _isSheetOpen = draggableControllerOfPreviewAddress.size > widget.initialSheetSize;
    setState(() {});
  }

  Future<void> expandSheet(double lat, double lon) async {
    setState(() {
      _latitud = lat;
      _longitud = lon;
    });
    if (!draggableControllerOfPreviewAddress.isAttached) return;

    await draggableControllerOfPreviewAddress.animateTo(
      widget.maxSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> collapseSheet() async {
    if (!draggableControllerOfPreviewAddress.isAttached) return;

    widget.onCloseForSearchAddress.call();
    await draggableControllerOfPreviewAddress.animateTo(
      widget.initialSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  Future<void> collapSheetForNavButton() async {
    if (draggableControllerOfPreviewAddress.isAttached) {
      await draggableControllerOfPreviewAddress.animateTo(
        widget.initialSheetSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ).timeout(const Duration(milliseconds: 350), onTimeout: () {});
    }
    await widget.onCloseForNavButtonExpandSheet.call();
  }

  bool isExpandedSheet() {
    if (!draggableControllerOfPreviewAddress.isAttached) return false;
    return _isSheetOpen;
  }

  void _dragFromHeaderSheet(DragUpdateDetails detail) {
    if (!draggableControllerOfPreviewAddress.isAttached) return;
    final heightSheet = MediaQuery.sizeOf(context).height;
    final nexRangeOfSheet =
        (draggableControllerOfPreviewAddress.size - detail.delta.dy / heightSheet)
            .clamp(widget.initialSheetSize, widget.maxSheetSize);
    draggableControllerOfPreviewAddress.jumpTo(nexRangeOfSheet);
  }

  void _dragEndFromHeaderSheet(DragEndDetails detail) {
    if (!draggableControllerOfPreviewAddress.isAttached) return;

    final drifVelocityOfHandle = detail.primaryVelocity ?? 0.0;
    const velocityThreshold = 900.0;
    final shouldClose = drifVelocityOfHandle > velocityThreshold ||
        draggableControllerOfPreviewAddress.size < (widget.maxSheetSize / 2);

    if (shouldClose) {
      collapseSheet();
      return;
    }

    final targetToGoSheet =
        draggableControllerOfPreviewAddress.size < _snapMidpoint
            ? widget.initialSheetSize
            : widget.maxSheetSize;

    draggableControllerOfPreviewAddress.animateTo(
      targetToGoSheet,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Functionality for close the sheet if is expand and touch out of the sheet.
        if (isExpandedSheet())
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: collapseSheet,
            child: const SizedBox.expand(),
          ),
        

        // -Sheet-
        // Handle of the sheet settings
        Align(
          alignment: Alignment.bottomCenter,
          child: DraggableScrollableSheet(
            controller: draggableControllerOfPreviewAddress,
            initialChildSize: widget.initialSheetSize,
            minChildSize: widget.minSheetSize,
            maxChildSize: widget.maxSheetSize,
            builder: (context, scrollControllerDefault) {
              return SafeArea(
                top: false,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.grey[300]!,width: 1,),),
                  ),

                  child: AnimatedOpacity(
                    opacity: _contentOpacity,
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeOutCubic,
                    child: LayoutBuilder(
                      builder: ((context, constraints) => Column(
                        children: [
                          // HEADER OF SHEET
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onVerticalDragUpdate: _dragFromHeaderSheet,
                                onVerticalDragEnd: _dragEndFromHeaderSheet,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                                  child: Column(
                                    children: [
                                      // Grab Bar
                                      BarraAgarre(),
                                      SizedBox(height: 8),

                                      // Text of header and button
                                      //Header del widget (Icon - Texto - Botones)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              // Icono location de direccion
                                              Container(
                                                padding: EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: camarone100,
                                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                                ),
                                                child: Icon(Icons.location_on_rounded,
                                                  size: 38,
                                                  color: camarone700
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              
                                              // Address
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10,),
                                                    child: Text('San Martín 123',
                                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Text('Ushuaia, Tierra del Fuego',
                                                      style: Theme.of(context).textTheme.bodyMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          
                                          // Icons of actions
                                          Row(
                                            children: [
                                              CircleIcon(icon: Icons.favorite,
                                                color:  Colors.grey,
                                                onPressed: () {
                                                },
                                              ),
                                              SizedBox(width: 20),
                                              CircleIcon(icon: Icons.close,
                                                onPressed: collapseSheet,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        
                          // BODY
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollControllerDefault,
                              child: Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(22, 20, 22, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Tips of preview address
                                    // --CARD--
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: camarone50,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(width: 1, color: camarone100),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Icon
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: camarone100,
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Icon(Icons.search, size: 30,)
                                          ),
                                          const SizedBox(width: 10,),

                                          // Text
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Dirección seleccionada',
                                                  style:Theme.of(context).textTheme.labelLarge?.copyWith(
                                                    fontWeight: FontWeight.bold
                                                  )
                                                ),
                                                const SizedBox(height: 5,),
                                                Text('Explorá la información ambiental disponible para esta ubicación.',
                                                  style: Theme.of(context).textTheme.labelSmall,
                                                  softWrap: true,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 40,),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    // Button of containers around
                                    CustomCardOptionSettings(
                                      // TODO: change for a dynamic text
                                      titulo: '7 contenedores cercanos',
                                      subtitulo: 'Encuentra puntos de reciclaje alrededor.',
                                      icon: Icon(Icons.delete, size: 25, color: camarone700,),
                                      actionSetting: () {
                                        //TODO: abre sheet de contenedores cercanos
                                      },
                                      color: camarone100,
                                      all: true,
                                      switchWidget: false,
                                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                                    ),
                                    const SizedBox(height: 8),

                                    // Button of info of zone
                                    CustomCardOptionSettings(
                                      titulo: 'Horarios de recolección en la zona',
                                      subtitulo: 'Consultar días y tipos de residuos.',
                                      icon: Icon(Icons.calendar_month, size: 25, color: camarone700,),
                                      actionSetting: () {
                                        //TODO: abre sheet de contenedores cercanos
                                      },
                                      color: camarone100,
                                      all: true,
                                      switchWidget: false,
                                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15),
                                    ),
                    
                                    // FOOTER
                                    //Botones de accion
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: OutlinedButton(
                                            onPressed: () {},
                                            child: Row(
                                              children: [
                                                const Icon(Icons.notifications_none,
                                                  color: Colors.black,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 6),
                                                Text('Recordarme'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        
                                        SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              
                                              await collapSheetForNavButton();

                                              await widget.searchDirection?.call( _latitud, _longitud, );
                                              
                                              await widget.openDetailDirection?.call();

                                              await widget.generateRouteWithCar?.call();
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(Icons.time_to_leave,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 6),
                                                Text('Navegar'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          )
                        ],
                      ))
                    ),
                  ),
                )
              );
            } 
          ),
        )
      ]  
    );
  }
}