import 'package:eco_ushuaia/features/home/presentation/widgets/card_touch.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/card_dynamic.dart';
import 'package:flutter/material.dart';

class UsefulAccess extends StatelessWidget{

  const UsefulAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return CardDynamic(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Header
          Text('Guía rápida', style: Theme.of(context).textTheme.titleMedium,),
          Text('Elegí cómo querés explorar la guía.', style: Theme.of(context).textTheme.bodyMedium,),

          // List of content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
               CardTouch(title: 'Cómo separar', 
                    infoText: 'Consejos básicos para preparar residuos antes de reciclar.', 
                    width: 250
                ),
                SizedBox(width: 10,),
                CardTouch(title: 'Que no va', 
                  infoText: 'Evitá errores comunes en contenedores de reciclaje.', 
                  width: 250
                ),
                SizedBox(width: 10,),
                CardTouch(title: 'Dónde llevarlo', 
                  infoText: 'Descubrí si va a un contenedor común o a un punto especial.', 
                  width: 250
                ),
                SizedBox(width: 10,),
                CardTouch(title: 'Ver materiales', 
                  infoText: 'Consultá materiales frecuentes y cómo descartarlos correctamente.', 
                  width: 250
                ),
                SizedBox(width: 10,),
                CardTouch(title: 'Residuos especiales', 
                  infoText: 'Identificá qué residuos necesitan puntos de recepción específicos.', 
                  width: 250
                ),
                SizedBox(width: 10,),
                CardTouch(title: 'Materiales frecuentes', 
                  infoText: 'Accedé rápido a los residuos más comunes de la guía.', 
                  width: 250
                ),
              ],
            )
          ),
        ],
      )
    );
  }
}