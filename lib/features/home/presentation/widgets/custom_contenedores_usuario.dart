import 'package:eco_ushuaia/features/home/presentation/widgets/card_touch.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/mini_map.dart';
import 'package:flutter/material.dart';

class CustomContenedoresUsuario extends StatelessWidget {
  const CustomContenedoresUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text('Contenedores favoritos', style: Theme.of(context).textTheme.headlineSmall),
        ),

        //Section of map
        Container(
          decoration: BoxDecoration(
            color: Colors.amberAccent
          ),
          child: Column(
            children: [
              Container(
                height: 290,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(width: 1.5, color: Colors.grey[400]!),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: const MiniMap(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Text('Tus ubicaciones', style: Theme.of(context).textTheme.titleMedium),
                  Text('Entrá directo a tus contenedores, a tu zona y a las búsquedas recientes.', style: Theme.of(context).textTheme.bodyMedium),
                  Row(
                    children: [
                      CardTouch(
                        title: 'Mi zona', 
                        infoText: 'Miércoles · 08:00 · Zona Centro.',
                        width: 200,
                      ),
                      CardTouch(
                        title: 'Estado de zona', 
                        infoText: 'Sin alertas críticas activas en tu zona principal.',
                        width: 200,
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
