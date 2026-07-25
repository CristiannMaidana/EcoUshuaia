import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class ContentSearchBarRecentSection extends StatelessWidget {
  const ContentSearchBarRecentSection ({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- SECTION OF FAVORITES CONTAINERS--
          // Text and button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Direcciones recientes', 
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  //TODO: key for expand sheet of all the favorite containers of the user
                }, 
                child: Text('Ver todos', 
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: camarone700),
                )
              ),
            ],
          ),
          const SizedBox(height: 10,),
          // Content of recent favorites containers
           // TODO: crear una opcion ternaria con la lista de recientes de provider
           Text('No hay direcciones recientes', style: Theme.of(context).textTheme.bodyLarge,),
        ],
      ),
    );
  }
}
