import 'package:eco_ushuaia/core/utils/hex_color.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartaDetallesRecientes extends StatelessWidget{
  final Contenedor? contenedor;
  //TODO: crear propiedades, (entidad, para tener los textos, id, y favorito de usuario), obtener elementos de icons
  CartaDetallesRecientes({
    super.key,
    this.contenedor,
  });

  @override
  Widget build (BuildContext context){
    final vmResiduos = context.watch<ResiduoViewmodel>();
    final Residuos? residuo = (contenedor != null && contenedor!.idResiduo != null)
        ? vmResiduos.getResiduo(contenedor!.idResiduo!)
        : null;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(16) 
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon del boton
              SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.circle, 
                  size: 20, 
                  color: residuo?.colorHex.toColor(),
                ),
              ),

              SizedBox(width: 12),

              //Texto de datos contenedor
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('${contenedor?.nombreContenedor} - ${residuo?.nombre}', textAlign: TextAlign.center),
                  Text('distancia - Recoleccion: hoy', textAlign: TextAlign.center),
                ],
              ),
            ],
          ),
          
          // Botones para interactar con el contenedor
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: (){}, 
                icon: Icon(Icons.favorite, color: Colors.yellow.shade600),
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
