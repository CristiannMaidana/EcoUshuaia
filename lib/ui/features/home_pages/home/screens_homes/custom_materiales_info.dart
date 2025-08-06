import 'package:flutter/material.dart';

class CustomMaterialesInfo extends StatefulWidget {
  
  @override
  State<CustomMaterialesInfo> createState() => _CustomMaterialesInfoState();
}

class _CustomMaterialesInfoState extends State<CustomMaterialesInfo> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Text('Materiales de reciclaje', style: Theme.of(context).textTheme.bodyLarge),
        ),
        
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(4, (index) {
                return Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(width: 1.5, color: Colors.grey[400]!),
                  ),
                );
              }),
            ],
          ),
        )
      ],
    );
  }
}