import 'package:eco_ushuaia/core/services/mapbox_initializer.dart';
import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/data/sources/local/location_service.dart';
import 'package:eco_ushuaia/features/map/domain/entities/place_location.dart';
import 'package:eco_ushuaia/features/map/presentation/services/mapbox_search_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapWidgetAddres extends StatefulWidget {
  final PlaceLocation? selectedPlace;
  final void Function(String address, double lat, double lon) onAddressChanged;

  const MapWidgetAddres({
    super.key,
    required this.onAddressChanged,
    this.selectedPlace,
  });

  @override
  State<MapWidgetAddres> createState() => _MapWidgetAddresState();
}

class _MapWidgetAddresState extends State<MapWidgetAddres> {
  static const _defaultLon = -68.3030;
  static const _defaultLat = -54.8019;

  final _searchService = MapboxSearchService();
  final _perms = LocationPermissionService.I;

  MapboxMap? _mapboxMap;
  bool _mapReady = false;
  bool _loadingAddress = false;
  bool _hasLocationPermission = false;
  double _selectedLat = _defaultLat;
  double _selectedLon = _defaultLon;

  @override
  void initState() {
    super.initState();
    MapboxInitializer.ensureInitialized();
    _initPermissionState();
  }

  @override
  void didUpdateWidget(covariant MapWidgetAddres oldWidget) {
    super.didUpdateWidget(oldWidget);
    final place = widget.selectedPlace;
    final oldPlace = oldWidget.selectedPlace;
    if (place == null) return;
    if (oldPlace?.lat == place.lat && oldPlace?.lon == place.lon) return;
    _selectPlace(place);
  }

  Future<void> _initPermissionState() async {
    final permission = await _perms.refreshStatus();
    if (!mounted) return;
    setState(() {
      _hasLocationPermission = permission.isGranted;
    });
    if (_hasLocationPermission) {
      await _setInitialLocation();
    }
  }

  Future<void> _retryPermission() async {
    final ok = await _perms.ensureWhenInUsePermission(context);
    if (!mounted) return;
    setState(() {
      _hasLocationPermission = ok;
    });
    if (ok) {
      await _setInitialLocation();
    }
  }

  Future<void> _setInitialLocation() async {
    try {
      final permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.always ||
          permission == geo.LocationPermission.whileInUse) {
        final position = await geo.Geolocator.getCurrentPosition(
          locationSettings: const geo.LocationSettings(
            accuracy: geo.LocationAccuracy.high,
          ),
        );
        if (!mounted) return;
        setState(() {
          _selectedLat = position.latitude;
          _selectedLon = position.longitude;
        });
      }
    } catch (_) {
      // Si falla ubicacion se usa Ushuaia por defecto.
    }

    await _moveCamera(_selectedLat, _selectedLon, zoom: 15);
    await _loadAddressFromPoint(_selectedLat, _selectedLon);
  }

  Future<void> _moveCamera(double lat, double lon, {double zoom = 15}) async {
    final map = _mapboxMap;
    if (map == null) return;
    await map.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(lon, lat)),
        zoom: zoom,
      ),
    );
  }

  Future<void> _loadAddressFromPoint(double lat, double lon) async {
    if (!mounted) return;
    setState(() {
      _loadingAddress = true;
    });

    try {
      final address = await _searchService.addressFromPoint(lat, lon);
      if (!mounted) return;
      final selectedStreet = (address == null || address.trim().isEmpty)
          ? 'Dirección no disponible'
          : address;
      setState(() {
        _selectedLat = lat;
        _selectedLon = lon;
      });
      widget.onAddressChanged(selectedStreet, lat, lon);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _selectedLat = lat;
        _selectedLon = lon;
      });
      widget.onAddressChanged('Dirección no disponible', lat, lon);
    } finally {
      if (mounted) {
        setState(() {
          _loadingAddress = false;
        });
      }
    }
  }

  Future<void> _selectPlace(PlaceLocation place) async {
    await _moveCamera(place.lat, place.lon);
    await _loadAddressFromPoint(place.lat, place.lon);
  }

  Future<void> _updateFromMapCenter() async {
    final map = _mapboxMap;
    if (map == null) return;

    final cameraState = await map.getCameraState();
    final center = cameraState.center;
    final lat = center.coordinates.lat.toDouble();
    final lon = center.coordinates.lng.toDouble();
    await _loadAddressFromPoint(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 280,
          margin: const EdgeInsets.only(left: 4, right: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                MapWidget(
                  key: const ValueKey('edit-address-map'),
                  styleUri: MapboxStyles.STANDARD,
                  cameraOptions: CameraOptions(
                    center: Point(
                      coordinates: Position(_selectedLon, _selectedLat),
                    ),
                    zoom: 15,
                  ),
                  onMapCreated: (map) async {
                    _mapboxMap = map;
                    if (!mounted) return;
                    setState(() {
                      _mapReady = true;
                    });
                    if (_hasLocationPermission) {
                      await _moveCamera(_selectedLat, _selectedLon);
                    }
                  },
                  onMapIdleListener: (_) {
                    if (_mapReady && _hasLocationPermission) {
                      _updateFromMapCenter();
                    }
                  },
                ),

                IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Image.asset('assets/icons/mapa/map_pin.png',
                      width: 42,
                      height: 42,
                    ),
                  ),
                ),
                if (_loadingAddress)
                  IgnorePointer(
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.18),
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(top: 12),
                      child: const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      ),
                    ),
                  ),
                  
                if (!_hasLocationPermission)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.black54),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Necesitamos tu ubicación para mostrarte en el mapa y ajustar el punto exacto.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: _retryPermission,
                                style: FilledButton.styleFrom(
                                  backgroundColor: camarone500,
                                ),
                                child: Text('Conceder permiso',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
