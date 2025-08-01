import 'package:eco_ushuaia/ui/core/ui/custom_lottie/custom_notification.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({Key? key}) : super (key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final List listaNotificaciones=List.empty(); //Simula ser la lista de todas las notificaciones de la base de dato

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions: [
          CustomNotification(notificaciones: listaNotificaciones)
        ],
      ),
    );
  }
}