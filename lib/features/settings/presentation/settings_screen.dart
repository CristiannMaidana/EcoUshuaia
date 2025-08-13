import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/layout/spacing.dart';
import 'package:eco_ushuaia/core/ui/icons/bell_icon_button.dart';
import 'package:eco_ushuaia/core/ui/animations/sun_night_lottie.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/settings_section.dart';
import 'package:eco_ushuaia/features/settings/presentation/edit_user_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget{
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool modoNoche = false;
  bool notificacion = false;
  
  void _onToggleModoNoche(bool value) {
    setState(() {
      modoNoche = value;
    });
  }
  
  void _onToggleNotificaciones(bool value) {
    setState(() {
      notificacion = value;
    });
  }

  final List<String> labelsUsuario = const [
    'Editar perfil',
    'Editar contraseña',
    'Editar direccion',
  ];

  final List<String> labelsSistema = const [
    'Desactivar notificaciones',
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> listaSistemaIcons = [
      BellIconButton(isActive: notificacion,),
      SunNightLottie(isNight: modoNoche,),
      Image.asset('assets/icons/settings/system/language.png'),
      Image.asset('assets/icons/settings/system/data-cleaning.png'),
      Image.asset('assets/icons/settings/system/info.png'),
      Image.asset('assets/icons/settings/system/file.png'),
      Image.asset('assets/icons/settings/system/delete-user.png'),
    ];

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
                      onToggleModoNoche: null,
                      onToggleNotificacion: null,
                    ),
                    espacioVerticalMediano,
                    SeccionAjustes(
                      titulo: Text('Sistema', style: Theme.of(context).textTheme.headlineLarge,),
                      lista: labelsSistema,
                      listPaginas: listaPaginas,
                      listaIcons: listaSistemaIcons,
                      onToggleModoNoche: _onToggleModoNoche,
                      onToggleNotificacion: _onToggleNotificaciones,
                    ),
                    espacioVerticalMediano,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: (){},
                          label: Text('Cerrar sesión'),
                          icon: Icon(Icons.logout, color: Colors.red, size: 35,),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                    espacioVerticalMediano,
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