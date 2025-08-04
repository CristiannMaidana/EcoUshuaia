import 'package:flutter/material.dart';

class CustomNovedades extends StatefulWidget{
  const CustomNovedades({Key? key}) : super(key: key);

  @override
  State<CustomNovedades> createState() => _CustomNovedadesState();
}

class _CustomNovedadesState extends State<CustomNovedades> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,   
      minChildSize: 0.4,       
      maxChildSize: 0.7,        
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22),
              topRight: Radius.circular(22),
            ),
            border: Border.all(color: Colors.grey[400]!, width: 1.5),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12, bottom: 12),
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}