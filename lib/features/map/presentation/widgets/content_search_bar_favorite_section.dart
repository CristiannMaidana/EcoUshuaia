import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/carta_detalles_recientes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentSearchBarFavoriteSection extends StatefulWidget {
  final Future<void> Function(Contenedor contenedor) goToContainer;

  const ContentSearchBarFavoriteSection({
    super.key, 
    required this.goToContainer
  });

  @override
  State<ContentSearchBarFavoriteSection> createState() => ContentSearchBarFavoriteSectionState();
}

class ContentSearchBarFavoriteSectionState extends State<ContentSearchBarFavoriteSection> {
  @override
  Widget build(BuildContext context) {
    final vmFavoritos = context.watch<UsuarioContenedoresFavoritosViewModel>();
    final favoritos = vmFavoritos.favoritos;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- SECTION OF FAVORITES CONTAINERS--
          // Text and button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Favoritos', 
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  //TODO: key for expand sheet of all the favorite containers of the user
                }, 
                child: Text('Ver todos', 
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: camarone700),
                )
              ),
            ],
          ),
          const SizedBox(height: 10,),
          // Content of recent favorites containers
           favoritos.isEmpty 
           ? Padding(
              padding: EdgeInsets.all(10),
              child: Text('No hay contenedores favoritos guardados'),
            )
            : Column(
                children: favoritos.reversed
                  .take(3)
                  .map(
                    (contenedor) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: CartaDetallesRecientes(
                        contenedor: contenedor,
                        deleteFavorito: () => vmFavoritos.removeFavoritoById(contenedor.idContenedor),
                        ir: widget.goToContainer,
                      ),
                    ),
                  ).toList(growable: false),
            ),
        ],
      ),
    );
  }
}
