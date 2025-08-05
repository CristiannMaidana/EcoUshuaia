import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_SizedBox.dart';
import 'package:flutter/material.dart';

class CustomItemsNovedades extends StatefulWidget{
  const CustomItemsNovedades({Key? key}) : super(key: key);

  @override
  State<CustomItemsNovedades> createState() => _CustomItemsNovedadesState();
}

class _CustomItemsNovedadesState extends State<CustomItemsNovedades> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(9, (index) {
          return Column(
            children: [
              espacioVerticalMediano,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: camarone400,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey.withOpacity(.6), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Diciembre'),
                        Text('32'),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Novedad tocada');
                    },
                    child: Container(
                      width: 300,
                      height: 80,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange[300],
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.grey[400]!, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Título de la novedad', style: Theme.of(context).textTheme.bodyLarge),
                          Text('Descripción breve de la novedad.', style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }
}