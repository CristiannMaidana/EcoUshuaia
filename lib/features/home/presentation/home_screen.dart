import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/domain/repositories/categoria_noticias_repositories.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/calendario_viewmodel.dart';
import 'package:eco_ushuaia/features/calendar/presentation/viewmodels/categoria_noticias_viewmodel.dart';
import 'package:eco_ushuaia/core/ui/animations/notification_lottie.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/quick_map.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/day_news.dart';
import 'package:eco_ushuaia/features/home/presentation/widgets/quick_actions.dart';
import 'package:eco_ushuaia/features/map/presentation/viewmodels/map_quick_action_viewmodel.dart';
import 'package:eco_ushuaia/features/news/presentation/novedades_screen.dart';
import 'package:eco_ushuaia/features/shell/presentation/navigation/shell_tab_selection_notification.dart';
import 'package:eco_ushuaia/features/shell/presentation/viewmodels/usuario_viewmodel.dart';
import 'package:eco_ushuaia/features/waste_instructions/presentation/waste_instructions_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List listaNotificaciones = List.empty(); //Simula ser la lista de todas las notificaciones de la base de dato

  @override
  Widget build(context) {
    final calendarioVm = context.watch<CalendarioViewmodel>();
    final usuarioVm = context.watch<UsuarioViewModel>();
    final nombreUsuario = usuarioVm.usuario?.nombreUsuario.trim();
    final saludoUsuario = nombreUsuario != null && nombreUsuario.isNotEmpty
        ? '¡Hola, $nombreUsuario!'
        : '¡Hola, Usuario!';

    return ChangeNotifierProvider(
      create: (context) => CategoriaNoticiasViewmodel(
        context.read<CategoriaNoticiasRepositories>(),
      )..load(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          // Text of header
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EcoUshuaia',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: camarone700)
                  ),
                  const SizedBox(height: 6),
                  Text(saludoUsuario,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('Bienvenido a tu ciudad más limpia',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Container(
              padding: EdgeInsets.only(right: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  border: Border.all(width: 1),
                ),
                child: NotificationLottie(notifications: listaNotificaciones),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuickActions(
                goMyZone: () {
                  context.read<MapQuickActionViewmodel>().openMyZone();
                  const ShellTabSelectionNotification(2).dispatch(context);
                },
                goCalendar: () {
                  const ShellTabSelectionNotification(1).dispatch(context);
                },
                goWasteGuide: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WasteInstructionsScreen(),
                    ),
                  );
                },
              ),
              QuickMap(),
              DayNews(news: calendarioVm.eventsOf(DateTime.now())),
              CustomNovedadesHome(
                news: calendarioVm.eventsFromDay(DateTime.now()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
