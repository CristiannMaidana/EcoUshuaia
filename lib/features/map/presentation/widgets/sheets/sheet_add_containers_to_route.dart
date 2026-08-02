import 'package:eco_ushuaia/core/theme/theme.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/carta_detalles_recientes.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/slider_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetAddContainersToRoute extends SheetGeneric {
  final double lon;
  final double lat;
  final ValueChanged<Contenedor> add;

  const SheetAddContainersToRoute({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.80,
    required this.lon,
    required this.lat,
    required this.add,
  });

  @override
  State<SheetAddContainersToRoute> createState() => SheetAddContainersToRouteState();
}

class SheetAddContainersToRouteState extends SheetGenericState<SheetAddContainersToRoute> {
  @override
  double get fadeStartSheetSize => initialChildSize + 0.10;

  @override
  Widget headerOfSheet(BuildContext context) {
    final contenedoresCercanos = context.watch<ContenedorViewModel>().contenedorCercanos;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Agregar parada',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text('Elegí uno o más contenedores para incluir en tu recorrido.',
                      style: Theme.of(context).textTheme.labelMedium,
                      softWrap: true,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 70),
              CircleIcon(icon: Icons.close, onPressed: collapseSheet),
            ],
          ),
          
          SliderCustom(lon: widget.lon, lat: widget.lat),
          Row(
            children: [
              const Icon(Icons.circle, size: 10, color: camarone600),
              const SizedBox(width: 10),
              Text('${contenedoresCercanos.length} contenedores encontrados',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    final vmContenedores = context.watch<ContenedorViewModel>();
    final contenedoresCercanos = vmContenedores.contenedorCercanos;

    return Expanded(
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          if (vmContenedores.loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (vmContenedores.error != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text(vmContenedores.error!)),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: CartaDetallesRecientes(
                    contenedor: contenedoresCercanos[index],
                    ir: (contenedor) async {
                      await collapseSheet();
                      widget.add(contenedor);
                    },
                    //TODO: implementar eliminar favorito desde la carta de detalles recientes
                    deleteFavorito: () {},
                  ),
                );
              }, childCount: contenedoresCercanos.length),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  @override
  Widget? footerOfSheet(BuildContext context) => null;
}
