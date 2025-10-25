import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:flutter/material.dart';

class NewReminder extends StatefulWidget{

  NewReminder({super.key});

  @override
  State<NewReminder> createState() => _StateNewReminder(); 
}

class _StateNewReminder extends State<NewReminder>{
  final _scrollCtrlTitulo = ScrollController();
  final _scrollCtrlNotas = ScrollController();

  @override
  void dispose() {
    _scrollCtrlTitulo.dispose();
    _scrollCtrlNotas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            //header
            SizedBox(height: 14,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleIcon(icon: Icons.close, onPressed: () {}),
                Text("Nuevo recordatorio", style: Theme.of(context).textTheme.bodyLarge,),
                CircleIcon(icon: Icons.check_sharp, onPressed: () {}),
              ],
            ),
            //Titulo y nota
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: BorderRadius.circular(32)
              ),
              child: Column(
                children: [
                  _label(context, _scrollCtrlTitulo, "Título"),
                  _label(context, _scrollCtrlNotas, "Notas"),
                ],
              ),
            )
            ],
        ),
      ),
    );
  }
}

Widget _label(context, _scrollCtrl, label){
  return Scrollbar(
    controller: _scrollCtrl,
    thumbVisibility: true,
    child: TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 4,
      scrollController: _scrollCtrl,
      style: Theme.of(context).textTheme.labelLarge,
      decoration: InputDecoration(
        hintText: label,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: true,
        fillColor: Colors.transparent,
      ),  
    ),
  ); 
}