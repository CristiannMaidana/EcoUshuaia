import 'package:eco_ushuaia/features/map/domain/repositories/contenedor_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/horario_recoleccion_filtros_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/usuario_contenedor_favoritos_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/zona_mapa_repository.dart';
import 'package:eco_ushuaia/features/map/presentation/controllers/map_native_coordinator.dart';
import 'package:eco_ushuaia/features/map/presentation/controllers/map_sheet_flow_controller.dart';
import 'package:eco_ushuaia/features/map/presentation/screens/mapa_screen.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_search_service.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/horario_recoleccion_filtros_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_search_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/zona_mapa_viewmodel.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContainerMapaScreen extends StatefulWidget{
  const ContainerMapaScreen({super.key});

  @override
  State<ContainerMapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<ContainerMapaScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ContenedorViewModel(ctx.read<ContenedorRepository>())..load(),
        ),
        ChangeNotifierProxyProvider2<
          UsuarioViewModel,
          ContenedorViewModel,
          UsuarioContenedoresFavoritosViewModel
        >(
          create: (ctx) => UsuarioContenedoresFavoritosViewModel(
            ctx.read<UsuarioContenedorFavoritosRepository>(),
          ),
          update: (_, usuarioVm, contenedorVm, favoritosVm) => favoritosVm!
            ..syncWithUserIdAndContenedores(
              usuarioVm.usuario?.idUsuario,
              contenedorVm.items,
            ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HorarioRecoleccionFiltrosViewModel(
            ctx.read<HorarioRecoleccionFiltrosRepository>(),
          )..initAll(),
        ),
        ChangeNotifierProvider(
          create: (_) => MapSearchViewModel(AddressSearchService()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ZonaMapaViewModel(ctx.read<ZonaMapaRepository>())..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MapNativeCoordinator(
            contenedorViewModel: ctx.read<ContenedorViewModel>(),
            zonaMapaViewModel: ctx.read<ZonaMapaViewModel>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MapSheetFlowController(),
        ),
      ],
      child: MapScreen(),
    );
  }
}