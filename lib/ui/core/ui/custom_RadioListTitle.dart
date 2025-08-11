import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';

enum MapStyle { Estandar, Satelite, Oscuro, Terreno }

class CustomRadiolisttitle extends StatelessWidget{
  final MapStyle? seleccionado;
  
  CustomRadiolisttitle({
    Key? key,
    required this.seleccionado,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _radio(context, MapStyle.Estandar, 'Estandar', 'assets/icons/mapa/map-standar.png'),
        _radio(context, MapStyle.Satelite, 'Satelite', 'assets/icons/mapa/map-route.png'),
        _radio(context, MapStyle.Oscuro, 'Oscuro', 'assets/icons/mapa/map-black.png'),
        _radio(context, MapStyle.Terreno, 'Terreno', 'assets/icons/mapa/map-mountain.png'),
      ],
    );
  }
  
  Widget _radio(BuildContext context, MapStyle value, String label, String asset) {
    return RadioListTile<MapStyle>(
      title: Row(
        children: [
          Image.asset(asset),
          const SizedBox(width: 20),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
      value: value,
      groupValue: seleccionado,
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: camarone600,
      splashRadius: 20,
      onChanged: (style) {
        if (style != null) Navigator.pop(context, style); 
      },
    );
  }
}