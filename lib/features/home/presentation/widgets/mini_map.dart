import 'package:eco_ushuaia/features/map/domain/repositories/contenedor_repository.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/usuario_contenedor_favoritos_repository.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_container_pins_bridge.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_navigation_map_view_bridge.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/mapbox_navigation_map_view.dart';
import 'package:eco_ushuaia/features/shell/presentation/navigation/shell_tab_selection_notification.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:provider/provider.dart';

class MiniMap extends StatefulWidget {
  const MiniMap({super.key});

  @override
  State<MiniMap> createState() => _MiniMapState();
}

class _MiniMapState extends State<MiniMap> with SingleTickerProviderStateMixin {
  double _latitude = -54.8070;
  double _longitude = -68.3047;
  MapboxNavigationMapViewBridge? _mapBridge;
  MapboxContainerPinsBridge? _containerPinsBridge;
  ContenedorViewModel? _contenedorVm;
  UsuarioContenedoresFavoritosViewModel? _favoritosVm;
  UsuarioViewModel? _usuarioVm;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contenedorVm ??= ContenedorViewModel(context.read<ContenedorRepository>())
      ..addListener(_syncFavoritos)
      ..load();
    _favoritosVm ??= UsuarioContenedoresFavoritosViewModel(context.read<UsuarioContenedorFavoritosRepository>())
      ..addListener(_updateFavoriteContainers);
    final usuarioVm = context.read<UsuarioViewModel>();
    if (_usuarioVm != usuarioVm) {
      _usuarioVm?.removeListener(_syncFavoritos);
      _usuarioVm = usuarioVm..addListener(_syncFavoritos);
    }
    _syncFavoritos();
  }

  void _syncFavoritos() {
    _favoritosVm?.syncWithUserIdAndContenedores(
      _usuarioVm?.usuario?.idUsuario,
      _contenedorVm?.items ?? const [],
    );
    _updateFavoriteContainers();
  }

  Future<void> _updateFavoriteContainers() async {
    final bridge = _containerPinsBridge;
    final favoritos = _favoritosVm?.favoritos;
    if (bridge == null) return;
    if (favoritos == null || favoritos.isEmpty) {
      await bridge.clearContainers();
    } else {
      await bridge.setContainers(favoritos);
    }
  }

  Future<void> _onMapReady(MapboxNavigationMapViewBridge bridge) async {
    _mapBridge = bridge;
    await _centerMapOnUser();
  }

  Future<void> _centerMapOnUser() async {
    try {
      var permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
      }
      if (permission == geo.LocationPermission.denied ||
          permission == geo.LocationPermission.deniedForever) {
        return;
      }
      final position = await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      await _mapBridge?.centerOnCoordinate(
        latitude: position.latitude,
        longitude: position.longitude,
        zoom: 15,
      );
    } catch (_) {}
  }

  void _onContainerPinsReady(MapboxContainerPinsBridge bridge) {
    _containerPinsBridge = bridge;
    _updateFavoriteContainers();
  }

  void _openMap() {
    const ShellTabSelectionNotification(2).dispatch(context);
  }

  @override
  void dispose() {
    _usuarioVm?.removeListener(_syncFavoritos);
    _contenedorVm?.removeListener(_syncFavoritos);
    _favoritosVm?.removeListener(_updateFavoriteContainers);
    _contenedorVm?.dispose();
    _favoritosVm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _openMap,
      child: AbsorbPointer(
        child: MapboxNavigationMapView(
          latitude: _latitude,
          longitude: _longitude,
          zoom: 13,
          onMapReady: _onMapReady,
          onContainerPinsReady: _onContainerPinsReady,
        ),
      ),
    );
  }
}
