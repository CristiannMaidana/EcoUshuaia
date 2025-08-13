import 'package:eco_ushuaia/core/theme/colors.dart';
import 'package:eco_ushuaia/core/ui/animations/chevron_lottie.dart';
import 'package:eco_ushuaia/core/ui/inputs/switch_toggle.dart';
import 'package:flutter/material.dart';

class SeccionAjustes extends StatefulWidget{
  final Widget titulo;
  final List<String> lista;
  final List<Widget> listPaginas;
  final List<Widget> listaIcons;
  final void Function(bool)? onToggleModoNoche;
  final void Function(bool)? onToggleNotificacion;


  const SeccionAjustes({
    Key? key,
    required this.titulo,
    required this.lista,
    required this.listPaginas,
    required this.listaIcons,
    required this.onToggleModoNoche,
    required this.onToggleNotificacion,
  }): super(key: key);

  @override
  State<SeccionAjustes> createState() => _SeccionAjustesState();
}

class _SeccionAjustesState extends State<SeccionAjustes> with SingleTickerProviderStateMixin{

  @override
  Widget build(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.titulo,
        Container(
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsetsGeometry.only(top: 8, bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1,color: Colors.grey.withOpacity(.2)),
            color: Colors.white
          ),
          child: Column(
            children: [
              ...List.generate(widget.lista.length, (index) {
                return Column(
                  children: [
                    Container(
                      height: 48,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.lista[index] != 'Desactivar notificaciones' && widget.lista[index] != 'Modo oscuro') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => widget.listPaginas[index]),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: camarone200,
                                      border: Border.all(width: 1, color: Colors.grey.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Center(child: widget.listaIcons[index])
                                  ),
                                  SizedBox(width: 20),
                                  Text(widget.lista[index], style: Theme.of(context).textTheme.labelLarge),
                                ],
                              ),
                            ),
                            if (widget.lista[index] != 'Desactivar notificaciones' && widget.lista[index] != 'Modo oscuro')
                              ChevronLottie(),
                            if (widget.lista[index] == 'Desactivar notificaciones' || widget.lista[index] == 'Modo oscuro')
                              if(widget.lista[index] == 'Modo oscuro')
                                SwitchToggle(onChanged: widget.onToggleModoNoche),
                              if(widget.lista[index] == 'Desactivar notificaciones')
                                SwitchToggle(onChanged: widget.onToggleNotificacion),
                          ],
                        ),
                      ),
                    ),
                    if (index < widget.lista.length - 1)
                      Divider(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ]
    );
  }
}