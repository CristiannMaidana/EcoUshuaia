import 'package:flutter/material.dart';

class CartaDetallesRecientes extends StatelessWidget{
  //TODO: crear propiedades, (entidad, para tener los textos, id, y favorito de usuario), obtener elementos de icons
  CartaDetallesRecientes({super.key});

  @override
  Widget build (BuildContext context){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(16) 
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          // Icon del boton
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            //TODO: cambia el icon en base a las propiedades del constructor
            child: Icon(Icons.circle, size: 20,),
          ),

          SizedBox(width: 12),

          //Texto de datos contenedor
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('nombre contenedor - residuo', textAlign: TextAlign.center),
                  Text('distancia - Recoleccion: hoy', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          
          // Botones para interactar con el contenedor
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: (){}, 
                icon: Icon(Icons.star, color: Colors.yellow.shade600),
                style: IconButton.styleFrom(
                  side: BorderSide(width: 1, color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              IconButton(
                onPressed: (){
                  // TODO: enviar id y generar ruta para ir
                }, 
                icon: Icon(Icons.arrow_forward),
                style: IconButton.styleFrom(
                  side: BorderSide(width: 1, color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
