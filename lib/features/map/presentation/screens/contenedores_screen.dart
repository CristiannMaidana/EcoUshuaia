import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/categories_popup_button.dart';
import 'package:eco_ushuaia/features/map/presentation/widgets/container_list_item.dart';
import 'package:flutter/material.dart';

class ContenedoresScreen extends StatefulWidget{

  ContenedoresScreen({
    Key ? Key,
  }): super (key: Key);

  @override
  State<ContenedoresScreen> createState() => _ContendoresScreenState();
}

class _ContendoresScreenState extends State<ContenedoresScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
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
              CategoriesPopupButton(),
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
                  30,
                  (index) => ContainerListItem(),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}