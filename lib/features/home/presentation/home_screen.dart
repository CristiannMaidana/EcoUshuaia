import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/domain/repositories/categoria_noticias_repositories.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/calendario_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:eco_ushuaia/core/ui/animations/notification_lottie.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/quick_map.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/day_news.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/quick_actions.dart';
import 'package:eco_ushuaia/features/news/presentation/novedades_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget{

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  final List listaNotificaciones=List.empty(); //Simula ser la lista de todas las notificaciones de la base de dato

  @override
  Widget build(context){
    final calendarioVm = context.watch<CalendarioViewmodel>();

    return ChangeNotifierProvider(
      create: (context) => CategoriaNoticiasViewmodel(context.read<CategoriaNoticiasRepositories>())..load(),
      child: Scaffold(
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
              QuickActions(),
              QuickMap(),
              DayNews(news: calendarioVm.eventsOf(DateTime.now())),
              CustomNovedadesHome(news: calendarioVm.eventsFromDay(DateTime.now())),
            ],
          ),
        )
      ),
    );
  }
}
