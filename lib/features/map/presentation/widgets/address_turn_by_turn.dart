import 'package:flutter/material.dart';

class AddressTurnByTurn extends StatefulWidget {
  final Map<String, dynamic> navigationPayload;
  final bool hasRoute;
  final bool isNavigating;
  final Future<void> Function()? onCancelNavigation;

  const AddressTurnByTurn({
    super.key,
    required this.navigationPayload,
    required this.hasRoute,
    required this.isNavigating,
    this.onCancelNavigation,
  });

  @override
  State<AddressTurnByTurn> createState() => _AddressTurnByTurnState();
}

class _AddressTurnByTurnState extends State<AddressTurnByTurn> {
  num? _totalDistance;
  num? _totalDuration;
  String? _routeSignature;

  @override
  void initState() {
    super.initState();
    _syncRouteTotals();
  }

  @override
  void didUpdateWidget(covariant AddressTurnByTurn oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncRouteTotals();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.hasRoute) {
      return const SizedBox.shrink();
    }

    final instruction = widget.navigationPayload['currentInstruction'] as String? ?? 'Ruta lista.';
    final maneuver = _maneuverPayload(widget.navigationPayload);
    final maneuverDistance = _maneuverDistance(widget.navigationPayload, maneuver);
    final totalDistance =
        _totalDistance ??
        _numberValue(widget.navigationPayload['distanceRemaining']);
    final totalDuration =
        _totalDuration ??
        _numberValue(widget.navigationPayload['durationRemaining']);

    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            _maneuverIcon(maneuver, instruction),
            size: 50,
            color: Colors.blueAccent[400],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Indicación: ${_distanceText(maneuverDistance)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  instruction,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Total: ${_distanceText(totalDistance)} · ${_minutesText(totalDuration)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (widget.isNavigating && widget.onCancelNavigation != null)
            IconButton(
              onPressed: widget.onCancelNavigation,
              icon: const Icon(Icons.cancel, size: 50),
              color: Colors.red,
            ),
        ],
      ),
    );
  }

  void _syncRouteTotals() {
    if (!widget.hasRoute) {
      _totalDistance = null;
      _totalDuration = null;
      _routeSignature = null;
      return;
    }

    final nextSignature = _routeSignatureFromPayload(widget.navigationPayload);
    final isNewRoute =
        nextSignature != null && nextSignature != _routeSignature;

    if (!isNewRoute && _totalDistance != null && _totalDuration != null) {
      return;
    }

    _routeSignature = nextSignature ?? _routeSignature;
    _totalDistance =
        _numberValue(widget.navigationPayload['distanceRemaining']) ??
        _totalDistance;
    _totalDuration =
        _numberValue(widget.navigationPayload['durationRemaining']) ??
        _totalDuration;
  }

  String? _routeSignatureFromPayload(Map<String, dynamic> payload) {
    final steps = payload['steps'];
    if (steps is! List || steps.isEmpty) return null;

    final firstStep = steps.first;
    final lastStep = steps.last;

    return [
      payload['routeProfile'],
      steps.length,
      _stepCoordinateSignature(firstStep),
      _stepCoordinateSignature(lastStep),
      _numberValue(payload['distanceRemaining'])?.round(),
      _numberValue(payload['durationRemaining'])?.round(),
    ].join('|');
  }

  String _stepCoordinateSignature(Object? step) {
    if (step is! Map) return '';

    final latitude = _numberValue(step['latitude']);
    final longitude = _numberValue(step['longitude']);

    return '${latitude?.toStringAsFixed(5)},${longitude?.toStringAsFixed(5)}';
  }

  //Helper para extraer el payload de maniobra relevante, priorizando currentVisualInstruction, luego nextManeuver, y finalmente currentStep, para asegurar que se muestre la información de maniobra más precisa y actualizada posible en la interfaz de navegación paso a paso.
  Map<String, dynamic> _maneuverPayload(Map<String, dynamic> payload) {
    final currentVisualInstruction = _usableManeuverPayload(
      payload['currentVisualInstruction'],
    );
    if (currentVisualInstruction != null) return currentVisualInstruction;

    final nextManeuver = _usableManeuverPayload(payload['nextManeuver']);
    if (nextManeuver != null) return nextManeuver;

    final currentStep = _usableManeuverPayload(payload['currentStep']);
    if (currentStep != null) return currentStep;

    return const <String, dynamic>{};
  }

  Map<String, dynamic>? _usableManeuverPayload(Object? value) {
    if (value is! Map || value.isEmpty) return null;

    final maneuver = Map<String, dynamic>.from(value);
    final hasManeuverData =
        _maneuverString(maneuver, 'maneuverType').isNotEmpty ||
        _maneuverString(maneuver, 'maneuverDirection').isNotEmpty;

    return hasManeuverData ? maneuver : null;
  }

  IconData _maneuverIcon(Map<String, dynamic> maneuver, String instruction) {
    final type = _maneuverString(maneuver, 'maneuverType').toLowerCase();
    final direction = _maneuverString(
      maneuver,
      'maneuverDirection',
    ).toLowerCase();
    final normalizedInstruction = instruction.trim().toLowerCase();

    if (type.contains('arrive') || type.contains('destination')) {
      return Icons.flag;
    }
    if (type.contains('roundabout') || type.contains('rotary')) {
      return direction.contains('left')
          ? Icons.roundabout_left
          : Icons.roundabout_right;
    }
    if (type.contains('uturn') || direction.contains('uturn')) {
      return direction.contains('right')
          ? Icons.u_turn_right
          : Icons.u_turn_left;
    }
    if (type.contains('fork')) {
      return direction.contains('right') ? Icons.fork_right : Icons.fork_left;
    }
    if (type.contains('merge')) {
      return Icons.merge_type;
    }
    if (direction.contains('left')) {
      return Icons.turn_left;
    }
    if (direction.contains('right')) {
      return Icons.turn_right;
    }
    if (type.contains('depart') ||
        type.contains('continue') ||
        direction.contains('straight') ||
        normalizedInstruction.contains('derecho') ||
        normalizedInstruction.contains('recto') ||
        normalizedInstruction.contains('straight')) {
      return Icons.straight;
    }

    return Icons.directions;
  }

  num? _maneuverDistance(
    Map<String, dynamic> payload,
    Map<String, dynamic> maneuver,
  ) {
    final currentVisualInstruction = payload['currentVisualInstruction'];
    if (currentVisualInstruction is Map) {
      final distanceAlongStep = _numberValue(
        currentVisualInstruction['distanceAlongStep'],
      );
      if (distanceAlongStep != null) return distanceAlongStep;
    }

    final maneuverDistance = _numberValue(maneuver['distance']);
    if (maneuverDistance != null) return maneuverDistance;

    return _numberValue(payload['stepDistanceRemaining']);
  }

  String _maneuverString(Map<String, dynamic> maneuver, String key) {
    final value = maneuver[key];
    if (value is String) return value.trim();
    return '';
  }

  num? _numberValue(Object? value) {
    if (value is num) return value;
    return null;
  }

  String _distanceText(num? meters) {
    if (meters == null) return '-- m';
    if (meters >= 1000) {
      final kilometers = meters / 1000;
      final decimals =
          kilometers >= 10 || kilometers == kilometers.roundToDouble() ? 0 : 1;

      return '${kilometers.toStringAsFixed(decimals)} km';
    }

    return '${meters.round()} m';
  }

  String _minutesText(num? seconds) {
    if (seconds == null) return '-- min';

    final minutes = seconds / 60;
    if (minutes > 0 && minutes < 1) return '1 min';

    return '${minutes.round()} min';
  }
}
