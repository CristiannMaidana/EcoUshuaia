import 'package:flutter/material.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('EcoUshuaia',
          style: TextStyle(color: Color(0xFF202020), fontSize: 45),),
        ),
        body: Center(
          child: Text('Welcome to the Login Screen!'),
        ),
      ),
    );
  }
}