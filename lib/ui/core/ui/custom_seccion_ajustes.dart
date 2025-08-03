import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_lottie/custom_chevron.dart';
import 'package:flutter/material.dart';

class SeccionAjustes extends StatefulWidget{
  final Widget titulo;
  final List<String> lista;
  final List<Widget> listPaginas;
  final List<Image> listaIcons;

  const SeccionAjustes({
    Key? key,
    required this.titulo,
    required this.lista,
    required this.listPaginas,
    required this.listaIcons,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => widget.listPaginas[index]),
                          );
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
                            CustomChevron(),
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