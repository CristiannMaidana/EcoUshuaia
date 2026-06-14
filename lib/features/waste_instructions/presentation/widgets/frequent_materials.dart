import 'package:eco_ushuaia/features/home/presentation/widgets/card_touch.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/screens/materials_screen.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/card_dynamic.dart';
import 'package:flutter/material.dart';

class FrequentMaterials extends StatelessWidget{

  const FrequentMaterials({super.key});

  @override
  Widget build(BuildContext context) {
    return CardDynamic(
      widget: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Materiales frecuentes', style: Theme.of(context).textTheme.titleMedium,),
                  Text('Accesos rápidos a los residuos más comunes.', style: Theme.of(context).textTheme.bodySmall,)
                ],
              ),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => MaterialsScreen()
                    )
                  );
                }, 
                child: Text('Ver todos')
              )
            ],
          ),

          // Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  height: 110,
                  child: CardTouch(title: 'Plastico', 
                    infoText: 'Envases, botellas y recipientes.', 
                    width: 250
                  ),
                ),
                SizedBox(width: 10,),
                CardTouch(title: 'Papel y cartón', 
                  infoText: 'Papel, cajas y cartones reciclables en buen estado', 
                  width: 250
                ),
                SizedBox(width: 10,),
                CardTouch(title: 'Vidrio', 
                  infoText: 'Botellas y frascos sin contenido ni tapas.', 
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