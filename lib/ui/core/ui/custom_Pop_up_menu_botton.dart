import 'package:flutter/material.dart';

class CustomPopUpMenuBotton extends StatefulWidget{
    
    CustomPopUpMenuBotton({
        Key ? key,
    }): super (key : key);

    @override
    State<CustomPopUpMenuBotton> createState() => _CustomPopUpMenuBottonState();
}

class _CustomPopUpMenuBottonState extends State<CustomPopUpMenuBotton> with SingleTickerProviderStateMixin{
    
    @override
    Widget build(BuildContext context) {
        return PopupMenuButton<String>(
            itemBuilder:(context) => [
                
            ],
        );
    }
}