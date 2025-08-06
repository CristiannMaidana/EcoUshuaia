import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/features/home_pages/settings/edit_user/edit_user_screen.dart';
import 'package:flutter/material.dart';

class CustomDatosUsuario extends StatefulWidget{
  
  @override
  State<CustomDatosUsuario> createState() => _CustomDatosUsuarioState();
}

class _CustomDatosUsuarioState extends State<CustomDatosUsuario> with SingleTickerProviderStateMixin{
  bool _historial = false; // Simula si hay historial de reciclaje o no

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      height: _historial ? 260 : 190,
      decoration: BoxDecoration(
        color: camarone200,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.grey[400]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //los datos del usuario
            Container(
              width: 300,
              height: 80,
              padding: EdgeInsets.only(left: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.grey[400]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre Apellido', style: Theme.of(context).textTheme.bodyLarge),
                  Text('Direccion', style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),         
            //los puntos de reciclaje o mensaje
            _historial? Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: camarone100,
                border: Border.all(width: 1.5, color: Colors.grey.withOpacity(.25)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.recycling, size: 40, color: Colors.blue),
                  Text('unidad', style: Theme.of(context).textTheme.labelMedium),
                  Text('papel', style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
            ) 
            : Padding(
              padding: const EdgeInsets.all(10),
              child: Text('No hay historial de reciclaje', style: Theme.of(context).textTheme.labelLarge),
            ),
            //el boton de editar datos
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditUserScreen()), 
                      );
                    }, 
                    style: TextButton.styleFrom(
                      backgroundColor: camarone400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                        side: BorderSide(color: Colors.grey[400]!, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10) 
                    ),
                    child: Text('Editar datos', style: Theme.of(context).textTheme.labelLarge)
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}