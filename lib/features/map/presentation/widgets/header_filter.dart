import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/button_filter_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderFilter extends StatelessWidget{
  final VoidCallback collapse;
  final VoidCallback aplicarFiltros;
  
  const HeaderFilter ({
    super.key,
    required this.collapse,
    required this.aplicarFiltros,
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
                    onPressed: () {
                      context.read<ButtonFilterViewmodel>().clean();
                      context.read<ContenedorViewModel>().clearAllFilter();
                      aplicarFiltros();
                    },
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
                      aplicarFiltros();
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