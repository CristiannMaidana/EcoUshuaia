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
          backgroundColor: Color.fromRGBO(0, 137, 50, 1),
          title: Text('EcoUshuaia',
            style: TextStyle(
              color: Colors.white,
              fontSize: 46,
              shadows: [
                Shadow(
                  color: Colors.black,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),],
            ),
          ),
        ),
        body: Center(
          child: Text('Welcome to the Login Screen!'),
        ),
      ),
    );
  }
}