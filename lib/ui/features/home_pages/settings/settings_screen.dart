import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuracion', style: Theme.of(context).textTheme.displayLarge,)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Cuenta'),
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Editar perfil'),
                        Icon(Icons.insert_chart_outlined_rounded)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 