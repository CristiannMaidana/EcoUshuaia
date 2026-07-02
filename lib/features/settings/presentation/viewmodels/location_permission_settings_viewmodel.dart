import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/data/sources/local/location_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionSettingsViewModel extends ChangeNotifier
    with WidgetsBindingObserver {
  final LocationPermissionService _permissionService;

  LocationPermissionSettingsViewModel(this._permissionService) {
    WidgetsBinding.instance.addObserver(this);
    _permissionService.statusNotifier.addListener(_handleStatusChanged);
    refresh();
  }

  bool _enabled = false;
  bool _busy = false;

  bool get enabled => _enabled;

  bool _isEnabledStatus(PermissionStatus status) {
    final state = _permissionService.toAppState(status);
    return state == AppLocationPermissionState.granted ||
        state == AppLocationPermissionState.limited;
  }

  Future<void> refresh() async {
    final status = await _permissionService.refreshStatus();
    _updateFromStatus(status);
  }

  Future<void> onToggleRequested(BuildContext context, bool value) async {
    if (_busy) return;

    _setBusy(true);
    try {
      await refresh();
      if (!context.mounted) return;

      if (value) {
        await _permissionService.openAppSettingsApp();
        await refresh();
        return;
      }

      final confirmed = await _showDisableConfirmationDialog(context);
      if (!context.mounted || !confirmed) {
        await refresh();
        return;
      }

      await _permissionService.openAppSettingsApp();
      await refresh();
    } finally {
      _setBusy(false);
    }
  }

  Future<bool> _showDisableConfirmationDialog(BuildContext context) async {
    final textTheme = Theme.of(context).textTheme;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Desactivar ubicación', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        content: SizedBox(
          height: 160,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Para quitar el acceso a tu ubicación tenés que hacerlo desde Ajustes del sistema.',
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  '¿Querés abrir Ajustes ahora?',
                  style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Alert info
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(22),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber, color: camarone700),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Algunas funciones podrían no funcionar correctamente.',
                          style: textTheme.labelMedium,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Row with buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Button secondary
              SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text('Cancelar'),
                ),
              ),
              // Button primary
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text('Abrir Ajustes'),
                ),
              ),
            ],
          ),

        ],
      ),
    );

    return result ?? false;
  }

  void _handleStatusChanged() {
    _updateFromStatus(_permissionService.statusNotifier.value);
  }

  void _updateFromStatus(PermissionStatus status) {
    final nextEnabled = _isEnabledStatus(status);
    if (_enabled == nextEnabled) return;
    _enabled = nextEnabled;
    notifyListeners();
  }

  void _setBusy(bool value) {
    if (_busy == value) return;
    _busy = value;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _permissionService.statusNotifier.removeListener(_handleStatusChanged);
    super.dispose();
  }
}
