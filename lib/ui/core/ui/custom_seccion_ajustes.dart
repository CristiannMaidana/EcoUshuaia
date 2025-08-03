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
    return Column();
  }
}