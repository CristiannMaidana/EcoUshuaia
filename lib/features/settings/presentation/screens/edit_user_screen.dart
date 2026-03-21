import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/adaptable_edit_option.dart';
import 'package:eco_ushuaia/features/settings/presentation/widgets/custom_card_option_settings.dart';
import 'package:flutter/material.dart';

class EditUserScreen extends StatefulWidget{

  const EditUserScreen({
    super.key,
  });

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> with SingleTickerProviderStateMixin{
  Future<void> _openEditPage({required String screenTitle, required String infoText, required List<AdaptableEditField> fields,}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdaptableEditOption(
          screenTitle: screenTitle,
          infoText: infoText,
          fields: fields,
        ),
      ),
    );
  }

  @override
  Widget build(context){
    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        backgroundColor: camarone50,
        title: Text('Editar perfil', style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsetsGeometry.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Datos personales', style: Theme.of(context).textTheme.headlineSmall,),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 10),
                child: Column(
                  children: [
                    CustomCardOptionSettings(titulo: 'Nombre completo', 
                      subtitulo: 'nombre usuario', 
                      icon: Icon(Icons.person_outline, size: 25),
                      actionSetting: () {
                        _openEditPage(
                          screenTitle: 'Editar nombre',
                          infoText:
                              'Verificá que el nombre y el apellido estén escritos correctamente, ya que se usarán para identificar tu cuenta.',
                          fields: const [
                            AdaptableEditField(keyName: 'nombre',
                              label: 'Nombre',
                              hintText: 'Ingrese un nuevo nombre completo',
                            ),
                            AdaptableEditField(keyName: 'apellido',
                              label: 'Apellido',
                              hintText: 'Ingrese un nuevo apellido',
                            ),
                          ],
                        );
                      }, 
                      color: camarone400.withValues(alpha: 0.2),
                      top: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                    CustomCardOptionSettings(titulo: 'Correo electrónico', 
                      subtitulo: 'usuario@correo.com', 
                      icon: Icon(Icons.mail_outline, size: 25),
                      actionSetting: (){}, 
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      all: false,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                    CustomCardOptionSettings(titulo: 'Teléfono', 
                      subtitulo: 'numero usuario', 
                      icon: Icon(Icons.smartphone_outlined, size: 25),
                      actionSetting: (){}, 
                      color: Colors.blueGrey.withValues(alpha: 0.2),
                      bottom: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
                      
              Text('Mi informacion util', style: Theme.of(context).textTheme.headlineSmall,),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 10),
                child: Column(
                  children: [
                    CustomCardOptionSettings(titulo: 'Domicilio principal', 
                      subtitulo: 'direccion de usuario, ciudad', 
                      icon: Icon(Icons.location_on_outlined, size: 25),
                      actionSetting: (){}, 
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      top: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                    CustomCardOptionSettings(titulo: 'Favoritos', 
                      subtitulo: 'Contenedores y lugares de reciclaje guardados.', 
                      icon: Icon(Icons.favorite_outline, size: 25),
                      actionSetting: (){}, 
                      color: camarone600.withValues(alpha: 0.2),
                      all: false,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                    CustomCardOptionSettings(titulo: 'Recordatorios activos', 
                      subtitulo: 'Avisos de calendario y eventos personales.', 
                      icon: Icon(Icons.calendar_today_outlined, size: 25),
                      actionSetting: (){}, 
                      color: Colors.orangeAccent.withValues(alpha: 0.2),
                      bottom: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
                                                              
              Text('Actividad y acciones de cuenta', style: Theme.of(context).textTheme.headlineSmall,),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 10),
                child: Column(
                  children: [
                    CustomCardOptionSettings(titulo: 'Búsquedas recientes', 
                      subtitulo: 'Direcciones y zonas consultadas recientemente.', 
                      icon: Icon(Icons.av_timer_outlined, size: 25),
                      actionSetting: (){}, 
                      color: Colors.blueGrey.withValues(alpha: 0.2),
                      top: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                    CustomCardOptionSettings(titulo: 'Cambiar contraseña', 
                      subtitulo: 'Actualizar credenciales de acceso de forma segura.', 
                      icon: Icon(Icons.lock_outlined, size: 25),
                      actionSetting: (){}, 
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      bottom: true,
                      switchWidget: false,
                      goIcon: Icon(Icons.arrow_forward_ios_outlined, size: 15,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
