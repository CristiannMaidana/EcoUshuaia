import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_SizedBox.dart';
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
    'Notificaciones',
    'Modo oscuro',
    'Lenguaje',
    'Limpiar cache',
    'Termino de uso',
    'Politicas de privacidad',
    'Eliminar cuenta',
  ];
  
  //Solo para testear
  final List<Widget> listaPaginas = const [
    EditUserScreen(),
    EditUserScreen(),
    EditUserScreen(),
  ];

  final List<Image> listaUsuarioIcons = [
    Image.asset('assets/icons/settings/user/user.png',),
    Image.asset('assets/icons/settings/user/lock.png'),
    Image.asset('assets/icons/settings/user/adress.png'),
  ];

  final List<Image> listaSistemaIcons = [
    Image.asset('assets/icons/settings/system/bell.png'),
    Image.asset('assets/icons/settings/system/bell.png'),
    Image.asset('assets/icons/settings/system/language.png'),
    Image.asset('assets/icons/settings/system/data-cleaning.png'),
    Image.asset('assets/icons/settings/system/info.png'),
    Image.asset('assets/icons/settings/system/file.png'),
    Image.asset('assets/icons/settings/system/delete-user.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(title: Text('Configuracion', style: Theme.of(context).textTheme.displayLarge,)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsetsGeometry.all(20),
                child: Column(
                  children: [
                    SeccionAjustes(
                      titulo: Text('Datos de ususario', style: Theme.of(context).textTheme.headlineLarge,), 
                      lista: labelsUsuario, 
                      listPaginas: listaPaginas,
                      listaIcons: listaUsuarioIcons,
                    ),
                    espacioVerticalMediano,
                    SeccionAjustes(
                      titulo: Text('Sistema', style: Theme.of(context).textTheme.headlineLarge,),
                      lista: labelsSistema,
                      listPaginas: listaPaginas,
                      listaIcons: listaSistemaIcons,
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
} 