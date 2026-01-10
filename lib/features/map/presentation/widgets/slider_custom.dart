import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//==== Clase para manejar el slider ====
// Maneja el vmContenedor unicamente para actualizar la 
//lista de contenedores que cumplan el radio modificable

class SliderCustom extends StatefulWidget {
  final double lon;
  final double lat;
  final int minRadiusM;
  final int maxRadiusM;
  final double initialRadiusM;

  const SliderCustom({
    super.key,
    required this.lon,
    required this.lat,
    this.minRadiusM = 100,
    this.maxRadiusM = 2000,
    this.initialRadiusM = 500,
  });

  @override
  State<SliderCustom> createState() => _SliderCustomState();
}

class _SliderCustomState extends State<SliderCustom> {
  late double _radiusM;

  // Carga la lista de contenedores filtrados por radio
  void _loadCercanos() {
    context.read<ContenedorViewModel>().loadCercanos(widget.lon, widget.lat, _radiusM.round(),);
  }

  @override
  void initState() {
    super.initState();
    _radiusM = widget.initialRadiusM.clamp(
      widget.minRadiusM.toDouble(),
      widget.maxRadiusM.toDouble(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadCercanos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contenedores cercanos:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Radio',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CupertinoSlider(
                  value: _radiusM,
                  min: widget.minRadiusM.toDouble(),
                  max: widget.maxRadiusM.toDouble(),
                  onChanged: (v) => setState(() => _radiusM = v),
                  onChangeEnd: (_) => _loadCercanos(),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 72,
                child: Text(
                  '${(_radiusM / 1000).toStringAsFixed(2)} km',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

