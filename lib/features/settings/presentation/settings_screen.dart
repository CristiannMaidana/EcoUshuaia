import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/auth/presentation/login_screen.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/custom_card_option_settings.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/perfil_option_settings.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget{
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

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
                margin: EdgeInsetsGeometry.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text('Cuenta', style: Theme.of(context).textTheme.headlineSmall,),
                    PerfilOptionSettings(nameUser: 'Cristian Maidana'),
                    SizedBox(height: 20),
          
                    Text('Notificaciones', style: Theme.of(context).textTheme.headlineSmall,),
                    CustomCardOptionSettings(titulo: 'Notificaciones push', 
                      subtitulo: 'Avisos generales, novedades y alertas importantes.', 
                      icon: Icon(Icons.notifications_outlined, size: 25),
                      actionSetting: (){}, 
                      color: Colors.orangeAccent.withValues(alpha: 0.2),
                      top: true,
                      switchWidget: true,
                    ),
                    CustomCardOptionSettings(titulo: 'Recordatorios de calendario', 
                      subtitulo: 'Eventos, anuncios, feriados y cambios de recorrido.', 
                      icon: Icon(Icons.calendar_today_outlined, size: 25),
                      actionSetting: (){}, 
                      color: camarone100,
                      all: false,
                      switchWidget: true,
                    ),
                    CustomCardOptionSettings(titulo: 'Alertas por zona', 
                      subtitulo: 'Mantenimiento, incidentes y cambios cercanos a tu ubicación.', 
                      icon: Icon(Icons.location_on_outlined, size: 25),
                      actionSetting: (){}, 
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      bottom: true,
                      switchWidget: true,
                    ),

                    SizedBox(height: 20),
                    Text('Mapa y Búsqueda', style: Theme.of(context).textTheme.headlineSmall),
                    CustomCardOptionSettings(titulo: 'Estilo de mapa', 
                      subtitulo: 'Apariencia del mapa base.', 
                      icon: Icon(Icons.map_outlined, size: 25),
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      actionSetting: (){},
                      top: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                    CustomCardOptionSettings(titulo: 'Radio de búsqueda por defecto', 
                      subtitulo: 'Sugerencias automáticas de contenedores cercanos.', 
                      icon: Icon(Icons.radar_outlined, size: 25),
                      color: Colors.greenAccent.withValues(alpha: 0.2),
                      actionSetting: (){},
                      all: false,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                    CustomCardOptionSettings(titulo: 'Usar mi ubicación', 
                      subtitulo: 'Mejora rutas, zonas y resultados cercanos.', 
                      icon: Icon(Icons.location_on_outlined, size: 25),
                      color: Colors.deepPurpleAccent.withValues(alpha: 0.2),
                      actionSetting: (){},
                      all: false,
                      switchWidget: true,
                    ),
                    CustomCardOptionSettings(titulo: 'Guardar búsquedas recientes', 
                      subtitulo: 'Direcciones, zonas y consultas frecuentes.', 
                      icon: Icon(Icons.map_outlined, size: 25),
                      color: Colors.orangeAccent.withValues(alpha: 0.2),
                      actionSetting: (){},
                      bottom: true,
                      switchWidget: true,
                    ),
                    
                    SizedBox(height: 20),
                    Text('Privacidad y Datos', style: Theme.of(context).textTheme.headlineSmall),
                    CustomCardOptionSettings(titulo: 'Historial de actividad', 
                      subtitulo: 'Consultas recientes y acciones guardadas.', 
                      icon: Icon(Icons.lock_outline, size: 25),
                      color: Colors.grey.withValues(alpha: 0.2),
                      actionSetting: (){},
                      top: true,
                      switchWidget: true,
                    ),
                    CustomCardOptionSettings(titulo: 'Compartir datos para mejoras', 
                      subtitulo: 'Uso anónimo para optimizar la app.', 
                      icon: Icon(Icons.visibility_outlined, size: 25),
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      actionSetting: (){},
                      all: false,
                      switchWidget: true,
                    ),
                    CustomCardOptionSettings(titulo: 'Borrar búsquedas y recientes', 
                      subtitulo: 'Elimina direcciones, zonas y elementos vistos.', 
                      icon: Icon(Icons.delete_outline, size: 25),
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      actionSetting: (){},
                      bottom: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),

                    SizedBox(height: 20),
                    Text('Soporte y sesión', style: Theme.of(context).textTheme.headlineSmall),
                    CustomCardOptionSettings(titulo: 'Ayuda y preguntas frecuentes', 
                      subtitulo: 'Mapa, residuos, búsqueda y reportes.', 
                      icon: Icon(Icons.help_outline, size: 25),
                      color: Colors.orangeAccent.withValues(alpha: 0.2),
                      actionSetting: (){},
                      top: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                    CustomCardOptionSettings(titulo: 'Versión de la app', 
                      subtitulo: 'Información del sistema instalada.', 
                      icon: Icon(Icons.timer_outlined, size: 25),
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      actionSetting: (){},
                      all: false,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                    CustomCardOptionSettings(titulo: 'Cerrar sesión', 
                      subtitulo: 'Salir de la cuenta en este dispositivo.', 
                      icon: Icon(Icons.logout_outlined, size: 25),
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      actionSetting: (){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      bottom: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
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
