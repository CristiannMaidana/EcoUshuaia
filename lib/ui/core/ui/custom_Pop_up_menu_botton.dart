import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';

class CustomPopUpMenuBotton extends StatefulWidget{
    //Esto tendria que ser traido de la base de datos ahora es una prueba
    final List<String> categorias;

    CustomPopUpMenuBotton({
        Key? key,
        this.categorias = const ['Todos', 'Plastico', 'Papel y carton', 'Vidrio', 'Metales', 'Organico', 'Residuos electronicos', 'Textiles', 'Residuos peligrosos', 'Residuos voluminosos', 'Residuos de construccion y demolicion', 'Residuos sanitarios'],
    }) : super(key: key);

    @override
    State<CustomPopUpMenuBotton> createState() => _CustomPopUpMenuBottonState();
}

class _CustomPopUpMenuBottonState extends State<CustomPopUpMenuBotton> with SingleTickerProviderStateMixin{
    
    @override
    Widget build(BuildContext context) {
        return PopupMenuButton<String>(
            offset: Offset(0, 50),
            onSelected: (value) {
                print("$value");//Deberia optimizar y hacer que sean los ids?
            },
            itemBuilder:(context) => List.generate(widget.categorias.length, 
                (i) => PopupMenuItem(
                    value: widget.categorias[i],
                    child: Text(widget.categorias[i], style: Theme.of(context).textTheme.labelLarge,)
                )
            ),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: camarone300,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.grey[400]!, width: 1),
                    boxShadow: const [
                        BoxShadow(
                            color: Colors.black38,
                            blurRadius: 9,
                            offset: Offset(1, 4),
                        ),
                    ],
                ),
                child: Text('Contenedores', style: Theme.of(context).textTheme.labelLarge,),
            ), 
        );
    } 
}