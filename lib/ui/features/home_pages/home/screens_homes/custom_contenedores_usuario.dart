import 'package:eco_ushuaia/ui/mapaUshuaia.dart';
import 'package:flutter/material.dart';

class CustomContenedoresUsuario extends StatefulWidget {
  const CustomContenedoresUsuario({Key? key}) : super(key: key);

  @override
  State<CustomContenedoresUsuario> createState() => _CustomContenedoresUsuarioState();
}

class _CustomContenedoresUsuarioState extends State<CustomContenedoresUsuario> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Text('Contenedores cercanos', style: Theme.of(context).textTheme.headlineLarge),
        ),
        Container(
          height: 325,
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(width: 1.5, color: Colors.grey[400]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: MapaUshuaia()
          ),
        ),
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),),
          child: Text('Filtrar', style: Theme.of(context).textTheme.labelLarge),
        ),
      ],
    );
  }
}