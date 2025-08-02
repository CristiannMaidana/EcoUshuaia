import 'package:eco_ushuaia/ui/core/ui/custom_lottie/custom_chevron.dart';
import 'package:eco_ushuaia/ui/features/home_pages/settings/edit_user/edit_user_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget{
  final List<String> labels = const [
    'Editar perfil',
    'Editar contraseña',
    'Editar direccion',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuracion', style: Theme.of(context).textTheme.displayLarge,)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos de ususario', style: Theme.of(context).textTheme.headlineLarge,),
            ...List.generate(labels.length, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),  
                child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditUserScreen()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(labels[index], style: Theme.of(context).textTheme.labelLarge,),
                            CustomChevron(),
                          ],
                        ),
                      ),
              );
            }),
          ]
        ),
      ),
    );
  }
} 