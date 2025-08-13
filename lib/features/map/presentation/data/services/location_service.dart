import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Estados de alto nivel para que la UI no dependa de PermissionStatus directamente.
enum AppLocationPermissionState {
  granted,
  denied,
  permanentlyDenied,
  restricted, // iOS (Control parental/MDM), o casos raros
  limited,    // iOS: acceso limitado
}

class LocationPermissionService {
  LocationPermissionService._();
  static final LocationPermissionService I = LocationPermissionService._();

  /// Notificador para que tus widgets puedan escuchar cambios.
  final ValueNotifier<PermissionStatus> statusNotifier =
      ValueNotifier<PermissionStatus>(PermissionStatus.denied);

  /// Refresca el estado actual sin pedir permiso.
  Future<PermissionStatus> refreshStatus() async {
    final status = await Permission.locationWhenInUse.status;
    statusNotifier.value = status;
    return status;
  }

  /// True si el servicio de ubicación del dispositivo está activo (GPS/Location Services).
  Future<bool> isLocationServiceEnabled() async {
    final s = await Permission.locationWhenInUse.serviceStatus;
    return s == ServiceStatus.enabled;
  }

  /// Pide el permiso WhenInUse (si hace falta). Devuelve true si quedó concedido.
  /// Si está 'permanentlyDenied', opcionalmente muestra un diálogo para ir a Ajustes.
  Future<bool> ensureWhenInUsePermission(
    BuildContext context, {
    bool showSettingsDialogIfPermanentlyDenied = true,
  }) async {
    // Estado actual
    final current = await refreshStatus();
    
    //Si esta activado no molesta al usuario
    if (current.isGranted) return true;

    // El sistema recomienda “rationale”, deberia poner diálogo antes de .request()? (Android)
    if (await Permission.locationWhenInUse.shouldShowRequestRationale) {
      final ok = await _showRationaleDialog(context);
      if (!ok) return false;
    }

    // Pedir permiso
    //Abre el dialogo nativo de SO (Runner/info)
    final after = await Permission.locationWhenInUse.request();
    statusNotifier.value = after;

    //Si abilito listo
    if (after.isGranted) return true;

    //Si lo denego para siempre, abrir ajustes
    if (after.isPermanentlyDenied && showSettingsDialogIfPermanentlyDenied) {
      await _showGoToSettingsDialog(context);
    }

    return false;
  }

  //Mapea el tipo de plugin en tipo propio 
  AppLocationPermissionState toAppState(PermissionStatus s) {
    if (s.isGranted) return AppLocationPermissionState.granted;
    if (s.isPermanentlyDenied) return AppLocationPermissionState.permanentlyDenied;
    if (s.isDenied) return AppLocationPermissionState.denied;
    if (s.isRestricted) return AppLocationPermissionState.restricted;
    if (s.isLimited) return AppLocationPermissionState.limited;
    return AppLocationPermissionState.denied;
  }

  //Lleva al usuario a ajustes
  Future<bool> openAppSettingsApp() async => await openAppSettings();

  //Un mensaje explicativo de porque la ubicacion
  Future<bool> _showRationaleDialog(BuildContext context) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Ubicación necesaria', style: Theme.of(context).textTheme.headlineLarge,),
        content: Text(
          'Necesitamos tu ubicación para mostrarte en el mapa y calcular la ruta a los contenedores cercanos.',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar', style: Theme.of(context).textTheme.labelLarge,)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text('Continuar', style: Theme.of(context).textTheme.labelLarge,)),
        ],
      ),
    );
    return res ?? false;
  }

  //Un mensaje explicativo par ir a ajustes
  Future<void> _showGoToSettingsDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Permiso bloqueado', style: Theme.of(context).textTheme.headlineLarge,),
        content: Text(
          'Denegaste la ubicación de forma permanente. Abrí Ajustes para habilitarla manualmente.',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cerrar', style: Theme.of(context).textTheme.labelLarge,)),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            style: FilledButton.styleFrom(
              backgroundColor: camarone500,
            ),
            child: Text(
              'Abrir Ajustes',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  //Liberar el ValueNotifier
  void dispose() {
    statusNotifier.dispose();
  }
}
