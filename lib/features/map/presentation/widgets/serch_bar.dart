import 'package:flutter/material.dart';

class SerchBar extends StatefulWidget{
  SerchBar({Key ? key}): super (key: key);

  @override
  State<SerchBar> createState() => _SerchBarState();
}

class _SerchBarState extends State<SerchBar> with SingleTickerProviderStateMixin{

  @override
  Widget build (BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 60,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(width: 1, color: Colors.black54),
        ),
      ),
    );
  }
}