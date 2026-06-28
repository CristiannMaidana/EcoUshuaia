import 'package:eco_ushuaia/features/calendar/presentation/widgets/line_divider.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/button_filter_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/usuario_contenedores_favoritos_viewmodel.dart';
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
    final vmButtonFilter = context.read<ButtonFilterViewmodel>();
    final vmContenedor = context.read<ContenedorViewModel>();
    final vmFavoritos = context.read<UsuarioContenedoresFavoritosViewModel>();

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 20, right: 15),
            child: Row(
              children: [
                //Titulo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filtros', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold)
                    ),
                    Text('Personalizá lo que ves en el mapa', style: Theme.of(context).textTheme.labelSmall,)
                  ],
                ),
                const Spacer(),
                
                //Boton limpiar filtros
                SizedBox(
                  height: 36, 
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey)
                    ),
                    onPressed: () {
                      vmButtonFilter.clean();
                      vmContenedor.clearAllFilter();
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
                    onPressed: () async {
                      collapse();
                      await vmContenedor.applyFilter(
                        vmButtonFilter.filtros,
                        filtrarFavoritos: vmButtonFilter.isSelected('Favoritos')
                            ? vmFavoritos.filtrarContenedoresFavoritos
                            : null,
                      );
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
