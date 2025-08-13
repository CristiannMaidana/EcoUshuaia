import 'dart:ui';
import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomNavegadorMapa extends StatefulWidget{
  final List<String> categories;

  CustomNavegadorMapa({
    Key ? key,
    this.categories = const ['Todos', 'Plastico', 'Papel y carton', 'Vidrio', 'Metales', 'Organico', 'Residuos electronicos', 'Textiles', 'Residuos peligrosos', 'Residuos voluminosos', 'Residuos de construccion y demolicion', 'Residuos sanitarios'],

  }): super (key: key);

  @override
  State<CustomNavegadorMapa> createState() => _CustomNavegadorMapaState();
}

class _CustomNavegadorMapaState extends State<CustomNavegadorMapa> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build (BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          height: 60,
          width: 400,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: camarone600.withOpacity(0.43),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(width: 1, color: Colors.black54),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    height: 40,
                    child: TextFormField(
                      key: Key('direction'),
                      style: TextStyle(
                        fontSize: 16,
                        color: camarone950  
                      ),
                      decoration: InputDecoration(
                        fillColor: camarone50.withOpacity(1),
                        hintText: 'Ingrese una direccion',
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.zero,
                      ),      
                      validator: (value) {
                        //Aca si la direccion es valida, muestra el mapa con el camino, 
                        //y levanta las opciones de que forma de ir quiere
                      },
                    ),
                  )
                ),
              ),
              SizedBox(width: 10,),
              PopupMenuButton<String>(
                offset: Offset(0, 50),
                onSelected: (value) {
                    print("$value");
                },
                itemBuilder:(context) => List.generate(widget.categories.length, 
                    (i) => PopupMenuItem(
                        value: widget.categories[i],
                        child: Text(widget.categories[i], style: Theme.of(context).textTheme.labelLarge,)
                    )
                ),
                child: TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: camarone50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        width: 1,
                        color: Colors.black87
                      )
                    )
                  ),
                  label: Row(
                    children: [
                      Image.asset('assets/icons/mapa/setting-lines.png'),
                      SizedBox(width: 10,),
                      Text('Filtro', style: Theme.of(context).textTheme.labelLarge,),
                    ],
                  )
                )
              ), 
            ],
          ),
        ),
      ),
    );
  }
}