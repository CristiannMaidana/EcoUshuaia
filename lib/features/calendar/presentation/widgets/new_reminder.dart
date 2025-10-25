import 'package:eco_ushuaia/features/calendar/presentation/widgets/circle_icon.dart';
import 'package:flutter/material.dart';

class NewReminder extends StatefulWidget{

  NewReminder({super.key});

  @override
  State<NewReminder> createState() => _StateNewReminder(); 
}

class _StateNewReminder extends State<NewReminder>{
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
          ],
        ),
      ),
    );
  }
}