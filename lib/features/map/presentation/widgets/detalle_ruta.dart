import 'package:flutter/material.dart';

class DetalleRuta extends StatefulWidget {
  final Future<void> Function() botonIr;
  final Map<String, dynamic> routePayload;

  //TODO: Recibir datos de la ruta, tiempo estimado, distancia, cantidad de residuos, tipo de residuo, etc.
  const DetalleRuta({
    super.key,
    required this.botonIr,
    required this.routePayload,
  });

  @override
  State<DetalleRuta> createState() => _DetalleRutaState();
}

class _DetalleRutaState extends State<DetalleRuta> {
  num? _totalDistance;
  num? _totalDuration;
  DateTime? _arrivalTime;
  String? _routeSignature;

  @override
  void initState() {
    super.initState();
    _syncRouteTotals();
  }

  @override
  void didUpdateWidget(covariant DetalleRuta oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncRouteTotals();
  }

  @override
  Widget build(BuildContext context) {
    final distance =
        _totalDistance ??
        _numberValue(widget.routePayload['distanceRemaining']);
    final duration =
        _totalDuration ??
        _numberValue(widget.routePayload['durationRemaining']);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Informacion de tiempo y distancia
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer, size: 20, color: Colors.black87),
                  const SizedBox(width: 8),
                  Text(
                    _minutesText(duration),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.place, size: 20, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    'Llegada: ${_arrivalText()} . ${_distanceText(distance)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          //Boton para iniciar la navegación
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: const StadiumBorder(),
              minimumSize: const Size(88, 44),
              padding: const EdgeInsets.symmetric(horizontal: 18),
            ),
            onPressed: () {
              widget.botonIr();
            },
            child: Text('IR', style: Theme.of(context).textTheme.labelLarge),
          ),
        ],
      ),
    );
  }

  void _syncRouteTotals() {
    if (widget.routePayload['hasRoute'] != true) {
      _totalDistance = null;
      _totalDuration = null;
      _arrivalTime = null;
      _routeSignature = null;
      return;
    }

    final nextSignature = _routeSignatureFromPayload(widget.routePayload);
    final isNewRoute =
        nextSignature != null && nextSignature != _routeSignature;

    if (!isNewRoute && _totalDistance != null && _totalDuration != null) {
      return;
    }

    final nextDistance = _numberValue(widget.routePayload['distanceRemaining']);
    final nextDuration = _numberValue(widget.routePayload['durationRemaining']);
    if (nextDistance == null && nextDuration == null) return;

    _routeSignature = nextSignature ?? _routeSignature;
    _totalDistance = nextDistance ?? _totalDistance;
    _totalDuration = nextDuration ?? _totalDuration;
    if (nextDuration != null) {
      _arrivalTime = DateTime.now().add(
        Duration(seconds: nextDuration.round()),
      );
    }
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
    if (seconds == null) return '-- minutos';

    final minutes = seconds / 60;
    if (minutes > 0 && minutes < 1) return '1 minuto';

    final roundedMinutes = minutes.round();
    return '$roundedMinutes ${roundedMinutes == 1 ? 'minuto' : 'minutos'}';
  }

  String _arrivalText() {
    final arrival = _arrivalTime;
    if (arrival == null) return '--:--';

    final hour = arrival.hour.toString().padLeft(2, '0');
    final minute = arrival.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
