import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/custom_card_option_settings.dart';
import 'package:flutter/material.dart';

class SheetPreviewAddress extends SheetGeneric {
  final Future<void> Function() onCloseForSearchAddress;
  final Future<void> Function() onCloseForNavButtonExpandSheet;
  final Future<void> Function(double lat, double lon)? searchDirection;
  final Future<void> Function()? openDetailDirection;
  final Future<void> Function()? generateRouteWithCar;

  const SheetPreviewAddress({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.50,
    required this.onCloseForSearchAddress,
    required this.onCloseForNavButtonExpandSheet,
    required this.generateRouteWithCar,
    required this.openDetailDirection,
    required this.searchDirection,
  });

  @override
  State<SheetPreviewAddress> createState() => SheetPreviewAddressState();
}

class SheetPreviewAddressState extends SheetGenericState<SheetPreviewAddress> {
  late double _latitud;
  late double _longitud;

  @override
  Future<void> expandSheet([double? lat, double? lon]) async {
    if (lat != null && lon != null) {
      setState(() {
        _latitud = lat;
        _longitud = lon;
      });
    }

    await super.expandSheet();
  }

  @override
  Future<void> collapseSheet() async {
    if (!draggableControllerOfSheet.isAttached) return;

    widget.onCloseForSearchAddress.call();
    await super.collapseSheet();
  }

  Future<void> collapSheetForNavButton() async {
    if (draggableControllerOfSheet.isAttached) {
      await draggableControllerOfSheet.animateTo(
        initialChildSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
      .timeout(const Duration(milliseconds: 350), onTimeout: () {});
    }
    await widget.onCloseForNavButtonExpandSheet.call();
  }

  @override
  Widget headerOfSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Column(
        children: [
          const BarraAgarre(),
          const SizedBox(height: 8),
          
          // Header row with title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: camarone100,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 38,
                      color: camarone700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        // TODO: change direction for the address selecter by the user in the search bar
                        child: Text('San Martín 123',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text( 'Ushuaia, Tierra del Fuego',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Close button and favorite button
              Row(
                children: [
                  CircleIcon(icon: Icons.favorite,
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  CircleIcon(icon: Icons.close, onPressed: collapseSheet),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(22, 20, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: camarone50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: camarone100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: camarone100,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(Icons.search, size: 30),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dirección seleccionada',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text('Explorá la información ambiental disponible para esta ubicación.',
                            style: Theme.of(context).textTheme.labelSmall,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomCardOptionSettings(
                titulo: '7 contenedores cercanos',
                subtitulo: 'Encuentra puntos de reciclaje alrededor.',
                icon: const Icon(Icons.delete, size: 25, color: camarone700),
                actionSetting: () {
                  //TODO: abre sheet de contenedores cercanos
                },
                color: camarone100,
                all: true,
                switchWidget: false,
                goIcon: const Icon(Icons.arrow_forward_ios_outlined, size: 15),
              ),
              const SizedBox(height: 8),
              CustomCardOptionSettings(
                titulo: 'Horarios de recolección en la zona',
                subtitulo: 'Consultar días y tipos de residuos.',
                icon: const Icon(Icons.calendar_month,
                  size: 25,
                  color: camarone700,
                ),
                actionSetting: () {
                  //TODO: abre sheet de contenedores cercanos
                },
                color: camarone100,
                all: true,
                switchWidget: false,
                goIcon: const Icon(Icons.arrow_forward_ios_outlined, size: 15),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.notifications_none,
                            color: Colors.black,
                            size: 24,
                          ),
                          SizedBox(width: 6),
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
                        await widget.searchDirection?.call(_latitud, _longitud);
                        await widget.openDetailDirection?.call();
                        await widget.generateRouteWithCar?.call();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.time_to_leave,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 6),
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
      ),
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) => null;
}
