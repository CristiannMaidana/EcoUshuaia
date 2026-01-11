import 'package:eco_ushuaia/core/utils/hex_color.dart';
import 'package:eco_ushuaia/features/map/domain/entities/contenedor.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuos.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/residuo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartaDetallesRecientes extends StatelessWidget{
  final Contenedor? contenedor;
  final VoidCallback? ir;
  //TODO: crear propiedades, (entidad, para tener los textos, id, y favorito de usuario), obtener elementos de icons
  CartaDetallesRecientes({
    super.key,
    this.contenedor,
    this.ir,
  });

  @override
  Widget build (BuildContext context){
    final vmResiduos = context.watch<ResiduoViewmodel>();
    final Residuos? residuo = (contenedor != null && contenedor!.idResiduo != null)
        ? vmResiduos.getResiduo(contenedor!.idResiduo!)
        : null;
    final vmContenedores = context.watch<ContenedorViewModel>();
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(22) 
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${contenedor?.nombreContenedor}', style: Theme.of(context).textTheme.labelLarge,),
                  Text('Residuo: ${residuo?.nombre}',),
                  Text('40 m - Recoleccion: hoy',),
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
                //TODO: el metodo ir para agregar valores, (nombre de contenedor - posicion)
                onPressed: (){
                  ir!();
                  vmContenedores.removeCercanoById(contenedor!.idContenedor);
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
