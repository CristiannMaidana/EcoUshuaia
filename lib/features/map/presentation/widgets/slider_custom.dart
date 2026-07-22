import 'package:eco_ushuaia/core/theme/theme.dart';
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
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Buscar en un radio de:',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(241, 241, 241, 1),
                  borderRadius: BorderRadius.all(Radius.circular(22))
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Center(
                  child: Text('${(_radiusM / 1000).toStringAsFixed(2)} km',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelMedium
                  ),
                ),
              ),
            ],
          ),
          // Slider
          Row(
            children: [
              Expanded(
                child: CupertinoSlider(
                  activeColor: camarone600,
                  value: _radiusM,
                  min: widget.minRadiusM.toDouble(),
                  max: widget.maxRadiusM.toDouble(),
                  onChanged: (v) => setState(() => _radiusM = v),
                  onChangeEnd: (_) => _loadCercanos(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

