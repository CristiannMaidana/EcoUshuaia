import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/shell/presentation/app_shell_screen.dart';
import 'package:eco_ushuaia/features/news/presentation/widgets/new_news_item.dart';
import 'package:flutter/material.dart';

class CustomNovedadesHome extends StatefulWidget{
  //Deberia traer las novedades desde la base de datos, o ya que esten aca?
  const CustomNovedadesHome({Key? key}) : super(key: key);

  @override
  State<CustomNovedadesHome> createState() => _CustomNovedadesScreenState();
}

class _CustomNovedadesScreenState extends State<CustomNovedadesHome> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('Novedades', style: Theme.of(context).textTheme.headlineLarge),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => ContainerHomeScreen(initialIndex: 1,)), 
                    (route) => false
                  );
                },
                 style: TextButton.styleFrom(
                  backgroundColor: camarone400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey[400]!, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                 child: Text('Ver todas', style: Theme.of(context).textTheme.labelLarge),
              ),
            ],
          ),
        ),
        Column(
          children: [
            ...List.generate(3, (index) {
              //Necesita ser cargado con datos de la base de datos
              return CustomNewNews();
            }),
          ],
        )
      ],
    );
  }
}