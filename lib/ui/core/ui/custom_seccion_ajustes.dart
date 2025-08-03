import 'package:eco_ushuaia/ui/core/ui/custom_lottie/custom_chevron.dart';
import 'package:flutter/material.dart';

class SeccionAjustes extends StatefulWidget{
  final Widget titulo;
  final List<String> lista;
  final List<Widget> listPaginas;

  const SeccionAjustes({
    Key? key,
    required this.titulo,
    required this.lista,
    required this.listPaginas,
  }): super(key: key);

  @override
  State<SeccionAjustes> createState() => _SeccionAjustesState();
}

class _SeccionAjustesState extends State<SeccionAjustes> with SingleTickerProviderStateMixin{

  @override
  Widget build(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.titulo,
        ...List.generate(widget.lista.length, (index) {
          return Container(
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 20),
            margin: EdgeInsets.symmetric(horizontal: 50),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.lista[index], style: Theme.of(context).textTheme.labelLarge,),
                  CustomChevron(),
                ],
              ),
            ),
          );
        }),
      ]
    );
  }
}