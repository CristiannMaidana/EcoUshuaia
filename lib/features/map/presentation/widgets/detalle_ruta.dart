import 'package:flutter/material.dart';

class DetalleRuta extends StatelessWidget {
  //TODO: Recibir datos de la ruta, tiempo estimado, distancia, cantidad de residuos, tipo de residuo, etc.
  const DetalleRuta({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12, offset: Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Informacion de tiempo y distancia
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.timer, size: 20, color: Colors.black87),
                  const SizedBox(width: 8),
                  Text('5 minutos', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.place, size: 20, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text('2 km . llegada: 18:46', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,),
                  ),
                ],
              ),
            ],
          ),

          //Informacion de conteendor
          //TOOD: cambiar para que solo aparezca si eligio un contenedor en parada
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              //TODO: Cambiar color según el tipo de residuo
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            // TODO: Mostrar la cantidad de residuo que tiene o que puede llevar?
            child: Text('0.34 kg', style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,),
            ),
          ),

          //Boton para iniciar la navegación
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: const StadiumBorder(),
              minimumSize: const Size(88, 44),
              padding: const EdgeInsets.symmetric(horizontal: 18),
            ),
            onPressed: () {
              //TODO: Iniciar la navegación y cerrar sheet
            },
            child: Text('IR', style: Theme.of(context).textTheme.labelLarge),  
          ),
        ],
      ),
    );
  }
}