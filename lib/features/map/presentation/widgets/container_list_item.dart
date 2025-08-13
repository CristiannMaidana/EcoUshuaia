import 'package:flutter/material.dart';

class ContainerListItem extends StatefulWidget{

  ContainerListItem({ 
    Key? key,
  }) : super(key: key);

  @override
  State<ContainerListItem> createState() => _CustomListaContenedoresState();
}

class _CustomListaContenedoresState extends State<ContainerListItem> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Toco boton'),
      child: Container(
        height: 75,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 50,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text('id contenedor', style: Theme.of(context).textTheme.labelMedium,)
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nombre personalizado', style: Theme.of(context).textTheme.labelMedium),
                  Text('tipo residuo', style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: Image.asset('assets/icons/mapa/pencil.png'),),
                  IconButton(onPressed: () {}, icon: Image.asset('assets/icons/mapa/delete.png')),
                ],
              ),
            ],
        ),
      ),
    );
  }
}