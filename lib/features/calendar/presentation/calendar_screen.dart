import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/calendar_basic.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/detail_news.dart';
import 'package:eco_ushuaia/features/calendar/presentation/widgets/drag_sheet_container.dart';
import 'package:eco_ushuaia/features/news/presentation/widgets/novedades_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});
  
  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<DragSheetContainerState> _sheetKey = GlobalKey<DragSheetContainerState>();
  Calendarios? _selectedCal;

  void _onNovedadTap(Calendarios c) {
    setState(() => _selectedCal = c);
    _sheetKey.currentState?.expand();
  }

  void _closeSheet() {
    _sheetKey.currentState?.collapse();
  }

  @override
  Widget build(BuildContext context) {
    final String fechaHoy = DateFormat('dd/MM/yy').format(DateTime.now());

    return Scaffold(
      backgroundColor: camarone50,
      appBar: AppBar(
        backgroundColor: camarone50,
        toolbarHeight: 60,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Calendario', style: Theme.of(context).textTheme.bodyLarge),
              Text('$fechaHoy', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              decoration: _Decoration(context),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    //Aca hay que abrir un nuevo widget, que este por encima de la ventana
                    //deberia desaparecer este boton y hacer efecto que se convierte en el widget grande,
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.black, size: 22,),
                    SizedBox(width: 8,),
                    Text('Recordatorio', style: Theme.of(context).textTheme.labelMedium,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 415,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey[400]!, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CalendarioWidget(), 
              ),
              const SizedBox(height: 400),
            ],
          ),

          CustomNovedades(expand:  _onNovedadTap),
          
          //Sheet de detalle de noticia
          DragSheetContainer(
            key: _sheetKey,
            child: DetailNews(newCalendar: _selectedCal, onClose: _closeSheet),
          )
        ],
      ),
    );
  }
}

BoxDecoration _Decoration(BuildContext context) {
  final borderColor = Colors.grey[400]!;
  return BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: borderColor, width: 1),
  );
}
