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
  @override
  Widget build(BuildContext context) {
    if (!widget.hasRoute) {
      return const SizedBox.shrink();
    }

    final instruction = widget.navigationPayload['currentInstruction'] as String? ?? 'Ruta lista.';
    final distanceRemaining = _numberValue(widget.navigationPayload['distanceRemaining']);
    final durationRemaining = _numberValue(widget.navigationPayload['durationRemaining']);
    final maneuver = _maneuverPayload(widget.navigationPayload);

    return Container(
      width: double.infinity,
      height: 100,
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
            _maneuverIcon(maneuver),
            size: 70,
            color: Colors.blueAccent[400],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instruction,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('Distancia: ${_metersText(distanceRemaining)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text('ETA: ${_secondsText(durationRemaining)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (widget.isNavigating && widget.onCancelNavigation != null)
            IconButton(
              onPressed: widget.onCancelNavigation,
              icon: const Icon(Icons.cancel),
              color: Colors.red,
            ),
        ],
      ),
    );
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

  IconData _maneuverIcon(Map<String, dynamic> maneuver) {
    final type = _maneuverString(maneuver, 'maneuverType').toLowerCase();
    final direction = _maneuverString(
      maneuver,
      'maneuverDirection',
    ).toLowerCase();

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
        direction.contains('straight')) {
      return Icons.straight;
    }

    return Icons.directions;
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

  String _metersText(num? meters) {
    if (meters == null) return '-- m';
    return '${meters.round()} m';
  }

  String _secondsText(num? seconds) {
    if (seconds == null) return '-- s';
    return '${seconds.round()} s';
  }
}
