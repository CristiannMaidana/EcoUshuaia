import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/animations/notification_lottie.dart';
import 'package:eco_ushuaia/features/home/presentation/screens/custom_contenedores_usuario.dart';
import 'package:eco_ushuaia/features/home/presentation/screens/user_data_screen.dart';
import 'package:eco_ushuaia/features/home/presentation/screens/materiales_info_screen.dart';
import 'package:eco_ushuaia/features/news/presentation/novedades_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{

  const HomeScreen({
    Key? key,
  }): super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  final List listaNotificaciones=List.empty(); //Simula ser la lista de todas las notificaciones de la base de dato

  @override
  Widget build(context){
    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        backgroundColor: camarone50,
        title: const Text('Eco Ushuaia', style: TextStyle(color: Colors.black)),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child:  Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(
                  width: 1
                )
              ),
              child: NotificationLottie(notifications: listaNotificaciones)
              ),
          )
        ],
      ),    
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomDatosUsuario(),
            CustomContenedoresUsuario(),
            CustomMaterialesInfo(),
            CustomNovedadesHome(),
          ],
        ),
      )
    );
  }
}