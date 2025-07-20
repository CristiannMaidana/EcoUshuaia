import 'package:flutter/material.dart';
import 'package:eco_ushuaia/ui/core/themes/container_decoration_theme.dart';

class RegisterScreen extends StatelessWidget{
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrate'), titleTextStyle: Theme.of(context).textTheme.headlineLarge,),
      body: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(25),
        decoration: containerInputsLogin,
        width: 500,
        height: 700,
      ),        
    );
  }
}