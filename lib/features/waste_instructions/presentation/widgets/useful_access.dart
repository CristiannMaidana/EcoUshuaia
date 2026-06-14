import 'package:eco_ushuaia/features/home/presentation/widgets/card_touch.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/screens/info_recicly_screen.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/widgets/card_dynamic.dart';
import 'package:flutter/material.dart';

class UsefulAccess extends StatelessWidget {
  const UsefulAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final guideItems = [
      (
        title: 'Cómo separar',
        infoText: 'Consejos básicos para preparar residuos antes de reciclar.',
        sectionId: 'como_separar',
      ),
      (
        title: 'Que no va',
        infoText: 'Evitá errores comunes en contenedores de reciclaje.',
        sectionId: 'que_no_va',
      ),
      (
        title: 'Dónde llevarlo',
        infoText: 'Descubrí si va a un contenedor común o a un punto especial.',
        sectionId: 'donde_llevarlo',
      ),
      (
        title: 'Ver materiales',
        infoText:
            'Consultá materiales frecuentes y cómo descartarlos correctamente.',
        sectionId: 'ver_materiales',
      ),
      (
        title: 'Residuos especiales',
        infoText:
            'Identificá qué residuos necesitan puntos de recepción específicos.',
        sectionId: 'residuos_especiales',
      ),
      (
        title: 'Materiales frecuentes',
        infoText: 'Accedé rápido a los residuos más comunes de la guía.',
        sectionId: 'materiales_frecuentes',
      ),
    ];

    return CardDynamic(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Header
          Text('Guía rápida', style: Theme.of(context).textTheme.titleMedium),
          Text(
            'Elegí cómo querés explorar la guía.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          // List of content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: guideItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CardTouch(
                    title: item.title,
                    infoText: item.infoText,
                    width: 250,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InfoReciclyScreen(sectionId: item.sectionId),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
