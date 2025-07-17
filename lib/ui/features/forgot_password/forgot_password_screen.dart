import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olvido contraseña'),
      ),
      body: Center(
        child: Text(
          '¡Bienvenido a la otra página!',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
