import 'package:flutter/material.dart';

class ButtonStartRoute extends StatefulWidget {
  final Future<void> Function() botonIr;
  final Map<String, dynamic> routePayload;

  //TODO: Recibir datos de la ruta, tiempo estimado, distancia, cantidad de residuos, tipo de residuo, etc.
  const ButtonStartRoute({
    super.key,
    required this.botonIr,
    required this.routePayload,
  });

  @override
  State<ButtonStartRoute> createState() => _ButtonStartRouteState();
}

class _ButtonStartRouteState extends State<ButtonStartRoute> {
  num? _totalDistance;
  num? _totalDuration;
  String? _routeSignature;

  @override
  void initState() {
    super.initState();
    _syncRouteTotals();
  }

  @override
  void didUpdateWidget(covariant ButtonStartRoute oldWidget) {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Informacion de tiempo y distancia
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Section of time
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer_sharp, size: 35, color: Colors.black87),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_minutesText(duration),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text('Tiempo estimado', 
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Section of distances
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.place_outlined, size: 35, color: Colors.black87),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_distanceText(distance),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text('Distancia',
                          style: Theme.of(context).textTheme.labelSmall
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 10,),
          //Boton para iniciar la navegación
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.botonIr();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Iniciar ruta'),
                  const SizedBox(width: 10),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _syncRouteTotals() {
    if (widget.routePayload['hasRoute'] != true) {
      _totalDistance = null;
      _totalDuration = null;
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
    if (seconds == null) return '-- min';

    final minutes = seconds / 60;
    if (minutes > 0 && minutes < 1) return '1 min';

    final roundedMinutes = minutes.round();
    return '$roundedMinutes ${roundedMinutes == 1 ? 'min' : 'min'}';
  }
}
