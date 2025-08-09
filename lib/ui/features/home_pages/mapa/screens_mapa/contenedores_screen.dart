import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';

class ContenedoresScreen extends StatefulWidget{

  ContenedoresScreen({
    Key ? Key,
  }): super (key: Key);

  @override
  State<ContenedoresScreen> createState() => _ContendoresScreenState();
}

class _ContendoresScreenState extends State<ContenedoresScreen> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: camarone50,
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: camarone300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: BorderSide(color: Colors.grey[400]!, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    minimumSize: Size(120, 40),
                    elevation: 5,
                    shadowColor: Colors.black
                  ),
                  child: Text('Favoritos', style: Theme.of(context).textTheme.labelLarge,),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}