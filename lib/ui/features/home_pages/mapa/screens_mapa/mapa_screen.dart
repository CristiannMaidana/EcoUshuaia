import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_mapa_controller.dart';
import 'package:flutter/material.dart';
import 'package:eco_ushuaia/data/services/location_service.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_mapa.dart';

class MapaScreen extends StatefulWidget {
   
  const MapaScreen({
    Key? key,
  }): super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final _perms = LocationPermissionService.I;
  bool _hasLocationPermission = false;
  CustomMapaController? _mapController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final ok = await _perms.ensureWhenInUsePermission(context);
      if (!mounted) return;
      setState(() => _hasLocationPermission = ok);

      if (ok && _mapController != null) {
        _mapController!.enableUserPuck();
      }
    });
  }

  Future<void> _retryPermission() async {
    final ok = await _perms.ensureWhenInUsePermission(context);
    if (!mounted) return;
    setState(() => _hasLocationPermission = ok);
    if (ok && _mapController != null) {
      _mapController!.enableUserPuck();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomMapa(
          onMapReady: (controller) {
            _mapController = controller;
            if (_hasLocationPermission) {
              controller.enableUserPuck();
            }
          },
        ),

        if (!_hasLocationPermission)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black54),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Necesitamos tu ubicación para mostrarte en el mapa y guiarte a contenedores cercanos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _retryPermission,
                      style: FilledButton.styleFrom(
                        backgroundColor: camarone500,
                      ),
                      child: Text('Conceder permiso', style: Theme.of(context).textTheme.labelLarge,),
                    ),
                  ],
                ),
              ),
            ),
          ),

        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            backgroundColor: camarone500,
            onPressed: () async {
              if (!_hasLocationPermission) {
                await _retryPermission();
                return;
              }
              await _mapController?.centerOnUserOnce(); 
            },
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}