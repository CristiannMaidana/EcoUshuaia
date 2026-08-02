import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/widgets/barra_agarre.dart';
import 'package:eco_ushuaia/core/ui/widgets/sheet_generic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/carta_detalles_recientes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SheetForShowAllTheFavoritesContainers extends SheetGeneric {
  final Future<void> Function(Contenedor contenedor) goToContainer;

  const SheetForShowAllTheFavoritesContainers({
    super.key,
    super.initialSheetSize = 0.00,
    super.minSheetSize = 0.00,
    super.maxSheetSize = 0.80,
    required this.goToContainer,
  });

  @override
  State<SheetForShowAllTheFavoritesContainers> createState() => SheetForShowAllTheFavoritesContainersState();
}

class SheetForShowAllTheFavoritesContainersState extends SheetGenericState<SheetForShowAllTheFavoritesContainers> {
  @override
  Widget headerOfSheet(BuildContext context) {
    final favoritos = context.watch<UsuarioContenedoresFavoritosViewModel>().favoritos;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Column(
        children: [
          const BarraAgarre(),
          const SizedBox(height: 8),
          
          // Header row with title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Favoritos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircleIcon(icon: Icons.close, onPressed: collapseSheet),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite, color: camarone600),
                  const SizedBox(width: 15),
                  Text('${favoritos.length} contenedores favoritos',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text('Ordenar',
                      style: Theme.of(context,).textTheme.labelLarge?.copyWith(
                        color: camarone600
                      ),
                    ),
                    
                    const SizedBox(width: 10),
                    const Icon(Icons.swap_vert, color: camarone600),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget bodyOfSheet(BuildContext context, ScrollController scrollController) {
    final vmFavoritos = context.watch<UsuarioContenedoresFavoritosViewModel>();
    final favoritos = vmFavoritos.favoritos;

    return Expanded(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(22, 8, 22, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              favoritos.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('No hay contenedores guardados'),
                    )
                  : Column(
                      children: favoritos.map(
                            (contenedor) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: CartaDetallesRecientes(
                                contenedor: contenedor,
                                deleteFavorito: () =>
                                    vmFavoritos.removeFavoritoById(
                                      contenedor.idContenedor,
                                    ),
                                ir: widget.goToContainer,
                              ),
                            ),
                          ).toList(growable: false),
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
