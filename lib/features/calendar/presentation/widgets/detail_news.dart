import 'package:eco_ushuaia/features/calendar/domain/entities/calendarios.dart';
import 'package:eco_ushuaia/features/news/presentation/widgets/info_grind.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailNews extends StatelessWidget{
  final Calendarios? newCalendar;
  final VoidCallback onClose;

  const DetailNews({super.key, this.newCalendar, required this.onClose});

  @override
  Widget build(BuildContext context) {
     final c = newCalendar;
    if (c == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Header
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Mapa
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.grey[400]!, width: 1),
                    ),
                    child: IconButton(onPressed: onClose, icon: Icon(Icons.map))
                  ),
                  SizedBox(width: 10,),
                  //Recordatorio
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.grey[400]!, width: 1),
                    ),
                    child: IconButton(onPressed: onClose, icon: Icon(Icons.add))
                  ),
                  SizedBox(width: 10,),
                  //Cerrar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.grey[400]!, width: 1),
                    ),
                    child: IconButton(onPressed: onClose, icon: Icon(Icons.close))
                  ),
                ],
              ),
              //Texto Categorias
              Container(
                width: 150,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.message_sharp),
                    SizedBox(width: 10),
                    Text("Categoria", style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              //Titulo Noticia
              Text(c.titulo, style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 20),
            ],
          ),
        ),
        //Datos fecha
        _lineDivider(context),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('dd/MM/yy – HH:mm').format(c.fechaHora), style: Theme.of(context).textTheme.labelMedium,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: TextButton(
                    onPressed: () =>{},
                    child: Row(
                      children: [
                        Icon(Icons.arrow_drop_down_sharp, color: Colors.black, size: 30,),
                        Text("Detalle de fecha", style: Theme.of(context).textTheme.labelMedium,),
                      ],
                    )
                  ),
                )
              ],
            ),
          ),
        ),
        //Datos residuo o nada
        _lineDivider(context),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: InfoGrid(
              items: const [
                InfoItem('Zona', 'Centro'),
                InfoItem('Categoría', 'Orgánicos'),
                InfoItem('Responsable', 'Higiene Urbana'),
                InfoItem('Contacto', '0800-XXX-1234'),
              ],
            ),
          ),
        ),
        //Texto de novedead
        _lineDivider(context),
        Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
            child: Text(c.novedad, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }
}

Divider _lineDivider (BuildContext context){
  return Divider(
    height: 1,
    color: Colors.black,
  );
}
