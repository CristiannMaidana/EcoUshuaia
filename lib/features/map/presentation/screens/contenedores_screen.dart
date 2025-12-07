import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/domain/repositories/contenedor_repository.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/contenedor_viewmodel.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/categories_popup_button.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/container_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContenedoresScreen extends StatelessWidget {
  const ContenedoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          ContenedorViewModel(ctx.read<ContenedorRepository>())..load(),
      child: ContenedorPage(),
    );
  }
}

class ContenedorPage extends StatefulWidget{

  ContenedorPage({
    Key ? Key,
  }): super (key: Key);

  @override
  State<ContenedorPage> createState() => _ContenedorPageState();
}

class _ContenedorPageState extends State<ContenedorPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ContenedorViewModel>();

    final categorias = vm.items
        .map((r) => r.residuo?.nombre)
        .whereType<String>()     
        .toSet()
        .toList()
      ..sort();
  
    return Scaffold(
      backgroundColor: camarone50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: camarone300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: BorderSide(color: Colors.grey[400]!, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    minimumSize: Size(120, 40),
                    elevation: 5,
                    shadowColor: Colors.black
                  ),
                  child: Text('Favoritos', style: Theme.of(context).textTheme.labelLarge,),
                ),
              ),
              CategoriesPopupButton(categorias: categorias,),
              //Aca deberia tener un callback para cambiar el setState
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text('Seleccione contenedor para ir', style: Theme.of(context).textTheme.bodyLarge,),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  vm.items.length,
                  (index) => ContainerListItem(contenedor: vm.items[index]),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}