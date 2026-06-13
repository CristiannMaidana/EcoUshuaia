import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/card_touch.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/mini_map.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/usuario_contenedor_favoritos_repository.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_quick_action_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/shell/presentation/navigation/shell_tab_selection_notification.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickMap extends StatelessWidget {
  const QuickMap({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UsuarioViewModel>().usuario?.idUsuario;

    return ChangeNotifierProvider(
      create: (context) {
        return UsuarioContenedoresFavoritosViewModel(
          context.read<UsuarioContenedorFavoritosRepository>(),
        );
      },
      child: Builder(
        builder: (context) {
          final favoritosVm = context.watch<UsuarioContenedoresFavoritosViewModel>();
          if (userId != null &&
              !favoritosVm.loadedOnce &&
              !favoritosVm.loading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              context.read<UsuarioContenedoresFavoritosViewModel>().loadByUsuario(userId);
            });
          }
          final favoritosCount = favoritosVm.getFavoritosCount();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('Contenedores favoritos', style: Theme.of(context).textTheme.headlineSmall),
              ),

              //Section of map and text
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(width: 1.5, color: Colors.grey[400]!),
                ),
                child: Column(
                  children: [
                    // Map
                    SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                              child: const MiniMap(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    lineDivider(),
                    SizedBox(height: 10),
                    // Text and buttos
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tus ubicaciones', style: Theme.of(context).textTheme.titleMedium),
                          Text('Entrá directo a tus contenedores, a tu zona y a las búsquedas recientes.', style: Theme.of(context).textTheme.bodyMedium),
                          // Cards with navigation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CardTouch(
                                title: 'Mi zona',
                                infoText: 'Centro · servicios y avisos personalizados',
                                width: 180,
                                onTap: () {
                                  context.read<MapQuickActionViewmodel>().openMyZone();
                                  const ShellTabSelectionNotification(2).dispatch(context);
                                },
                              ),
                              CardTouch(
                                title: 'Favoritos',
                                infoText: 'Tus contenedores guardados.($favoritosCount)',
                                width: 180,
                                onTap: () {
                                  context.read<MapQuickActionViewmodel>().openFavoritos();
                                  const ShellTabSelectionNotification(2).dispatch(context);
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  const ShellTabSelectionNotification(2).dispatch(context);
                                },
                                child: Row(
                                  children: [
                                    Text('Abrir mapa'),
                                    SizedBox(width: 10,),
                                    Icon(Icons.arrow_forward_ios_outlined),
                                  ],
                                )
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton(
                                onPressed: () {
                                  context.read<MapQuickActionViewmodel>().openSearchAddress();
                                  const ShellTabSelectionNotification(2).dispatch(context);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.add),
                                    SizedBox(width: 10,),
                                    Text('Buscar direccion'),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
