import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/carta_detalles_recientes.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/expansion_tile_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentSearch extends StatefulWidget {
  const ContentSearch({super.key});

  @override
  State<ContentSearch> createState() => ContentSearchState();
}

class ContentSearchState extends State<ContentSearch> {
  @override
  Widget build(BuildContext context) {
    final vmFavoritos = context.watch<UsuarioContenedoresFavoritosViewModel>();
    final favoritos = vmFavoritos.favoritos;

    return Column(
      children: [
        // Seccion de favoritos
        Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
          child: ExpansionTileCustom(
            title: 'Favoritos',
            initiallyOpen: true,
            child: favoritos.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('No hay contenedores favoritos guardados'),
                  )
                : Column(
                    children: favoritos
                        .map(
                          (contenedor) => Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: CartaDetallesRecientes(
                              contenedor: contenedor,
                              deleteFavorito: () => vmFavoritos.removeFavoritoById(contenedor.idContenedor),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
          ),
        ),
      ],
    );
  }
}
