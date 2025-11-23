import 'package:flutter/material.dart';

class RepeatReminder extends StatelessWidget{
  const RepeatReminder({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(Icons.event_repeat),
                const SizedBox(width: 16,),
                Text('Repetir', style: Theme.of(context).textTheme.labelMedium,),
                    TextButton(
                      onPressed: (){}, 
                      child: Row(
                        children: [
                          Text("data"),
                          Icon(Icons.rowing)
                        ],
                      )
                    )
                  ],
                ),
            ),
          ),
        ),
    );
  }
}