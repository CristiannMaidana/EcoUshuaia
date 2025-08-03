import 'package:eco_ushuaia/ui/core/ui/custom_seccion_ajustes.dart';
import 'package:eco_ushuaia/ui/features/home_pages/settings/edit_user/edit_user_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget{
  final List<String> labelsUsuario = const [
    'Editar perfil',
    'Editar contraseña',
    'Editar direccion',
  ];

  final List<String> labelsSistema = const [
    'Modo oscuro',
    'Lenguaje',
    'Limpiar cache',
    'Termino de uso',
    'Politicas de privacidad'
    'Eliminar cuenta',
  ];
  
  //Solo para testear
  final List<Widget> listaPaginas = const [
    EditUserScreen(),
    EditUserScreen(),
    EditUserScreen(),
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
            SeccionAjustes(
              titulo: Text('Datos de ususario', style: Theme.of(context).textTheme.headlineLarge,), 
              lista: labelsUsuario, 
              listPaginas: listaPaginas
            )
          ]
        ),
      ),
    );
  }
} 