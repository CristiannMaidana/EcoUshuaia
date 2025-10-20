import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/layout/spacing.dart';
import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemsNovedades extends StatefulWidget{
  final List<Calendarios> listaNovedades;

  ItemsNovedades({
    Key? key,
    required this.listaNovedades,
  }) : super(key: key);

  @override
  State<ItemsNovedades> createState() => _ItemsNovedadesState();
}

class _ItemsNovedadesState extends State<ItemsNovedades> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();

    return Column(
      children: [
        ...List.generate(widget.listaNovedades.length, (index) {
          final n = widget.listaNovedades[index];
          final mes = DateFormat.MMM(locale).format(n.fechaHora).toUpperCase();
          final dia = n.fechaHora.day.toString().padLeft(2, '0');
      
          return Column(
            children: [
              espacioVerticalMediano,
              GestureDetector(
                onTap: () {
                  //Aca deberia cargar una nueva pantalla con la novedad
                  //Se le cargara el objeto de la novedad
                  //La nueva ventana entendera y imprimira correctamente segun la novedad seleccionada
                  //La novedad tiene que ser una lista y coincidir los index con la lista de elementos
                  print('Novedad tocada');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: camarone400,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.grey.withOpacity(.6), width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mes, style: Theme.of(context).textTheme.labelMedium),
                          Text(dia, style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                    ),
                    Container(
                      width: 300,
                      height: 70,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 232, 211, 89),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.grey[400]!, width: 1.5),
                      ),
                      child: Text(n.titulo, style: Theme.of(context).textTheme.labelMedium),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}