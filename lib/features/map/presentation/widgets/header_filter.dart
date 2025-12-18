import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:flutter/material.dart';

class HeaderFilter extends StatelessWidget{
  final VoidCallback collapse;
  
  const HeaderFilter ({
    super.key,
    required this.collapse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                //Titulo
                Text('Filtros', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                
                //Boton limpiar filtros
                SizedBox(
                  height: 36, 
                  width: 93,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey)
                    ),
                    onPressed: () {}, // TODO: agregar metodo reseteador de filtros 
                    child: const Text('Limpiar', style: TextStyle(fontSize: 13))
                  ),
                ),
                const SizedBox(width: 8),
                
                //Boton aplicar filtros
                SizedBox(
                  height: 36, 
                  width: 93,
                  child: ElevatedButton(
                    // TODO: agregar metodo asincronico para que se cargue el mapa los filtros
                    onPressed: () {
                      collapse();
                    }, 
                    child: const Text('Aplicar', style: TextStyle(fontSize: 13),)
                  ),
                ),
              ],
            ),
          ),
        ),
        lineDivider(),
      ],
    );
  }
}