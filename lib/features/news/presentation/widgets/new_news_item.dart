import 'package:flutter/material.dart';

class CustomNewNews extends StatefulWidget {
  //Necesita el constructor para los objetos noticias
  const CustomNewNews({Key? key}) : super(key: key);

  @override
  State<CustomNewNews> createState() => _CustomNewNewsState();
}

class _CustomNewNewsState extends State<CustomNewNews> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(width: 1, color: Colors.grey[400]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 0.9,
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.article, size: 60, color: Colors.blue), //Cambiar icon según sea necesario o usar una imagen?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Esto viene del objeto de la base de datos
                Text('Nueva noticia', style: Theme.of(context).textTheme.bodyLarge),
                Text('Descripción breve de la noticia', style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}