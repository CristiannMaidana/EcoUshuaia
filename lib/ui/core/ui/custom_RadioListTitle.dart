import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';

class CustomRadiolisttitle extends StatefulWidget{
  final List<String> texto;
  
  CustomRadiolisttitle({
    Key? key,
    required this.texto,
  }): super(key: key);

  @override
  State<CustomRadiolisttitle> createState() => _CustomRadiolisttitleState();
}

class _CustomRadiolisttitleState extends State<CustomRadiolisttitle> {
  late String opcionSeleccionada = '';

  @override
  Widget build(BuildContext constext) {
    return Column(
      children: [
        RadioListTile<String>(
          title: Row(
            children: [
              Image.asset('assets/icons/mapa/map-standar.png'),
              SizedBox(width: 20,),
              Text(widget.texto[0], style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          value: widget.texto[0], 
          groupValue: opcionSeleccionada, 
          controlAffinity: ListTileControlAffinity.trailing,
          activeColor: camarone600,
          splashRadius: 20,
          radioScaleFactor: 1.5,
          onChanged: (value) {
            setState(() {
              opcionSeleccionada = value!;
            });
          }
        ),        
        RadioListTile<String>(
          title: Row(
            children: [
              Image.asset('assets/icons/mapa/map-route.png'),
              SizedBox(width: 20,),
              Text(widget.texto[1], style: Theme.of(context).textTheme.bodyLarge,),
            ],
          ),
          value: widget.texto[1], 
          groupValue: opcionSeleccionada, 
          controlAffinity: ListTileControlAffinity.trailing,
          activeColor: camarone600,
          splashRadius: 20,
          radioScaleFactor: 1.5,        
          onChanged: (value) {
            setState(() {
              opcionSeleccionada = value!;
            });
          }
        ),        
        RadioListTile<String>(
          title: Row(
            children: [
              Image.asset('assets/icons/mapa/map-black.png'),
              SizedBox(width: 20,),
              Text(widget.texto[2], style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          value: widget.texto[2], 
          groupValue: opcionSeleccionada, 
          controlAffinity: ListTileControlAffinity.trailing,
          activeColor: camarone600,
          splashRadius: 20,
          radioScaleFactor: 1.5,        
          onChanged: (value) {
            setState(() {
              opcionSeleccionada = value!;
            });
          }
        ),        
        RadioListTile<String>(
          title: Row(
            children: [
              Image.asset('assets/icons/mapa/map-mountain.png'),
              SizedBox(width: 20,),
              Text(widget.texto[3], style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          value: widget.texto[3], 
          groupValue: opcionSeleccionada, 
          controlAffinity: ListTileControlAffinity.trailing,
          activeColor: camarone600,
          splashRadius: 20,
          radioScaleFactor: 1.5,        
          onChanged: (value) {
            setState(() {
              opcionSeleccionada = value!;
            });
          }
        ),
      ],
    );
  }
}