import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_SizedBox.dart';
import 'package:flutter/material.dart';

class CustomItemsNovedades extends StatefulWidget{
  //Tiene que venir tanto lista novedades como lista mensajes
  List<Widget> listaNovedades;

  CustomItemsNovedades({
    Key? key,
    required this.listaNovedades,
  }) : super(key: key);

  @override
  State<CustomItemsNovedades> createState() => _CustomItemsNovedadesState();
}

class _CustomItemsNovedadesState extends State<CustomItemsNovedades> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.listaNovedades.length, (index) {
          return Column(
            children: [
              espacioVerticalMediano,
              GestureDetector(
                onTap: () {
                  //Aca deberia cargar una nueva pantalla con la novedad
                  //Se le cargara el objeto de la novedad
                  //La nueva ventana entendera y imprimira correctamente segun la novedad seleccionada
                  //La novedad tiene que ser una lista y coincidir los index con la lista de elementos
                  print('Novedad tocada');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: camarone400,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.grey.withOpacity(.6), width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Estos datos tienen que venir del objeto novedades
                          Text('DIC'),
                          Text('32'),
                        ],
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 70,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 232, 211, 89),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.grey[400]!, width: 1.5),
                      ),
                      //Este dato tiene que venir del objeto novedades
                      child:Text('Título de la novedad', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}