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
        body: Container(
          alignment: Alignment.center,
          color: Color.fromRGBO(0, 137, 50, 1),
          padding: EdgeInsets.all(25), // Add padding to the body
          
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(48, 209, 88, 1),
              borderRadius: BorderRadius.circular(50), // Rounded corners
              border: Border.all(
                color: Color.fromRGBO(10, 20, 13, 0.498),
                width: 1, // Border width
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 7),
                  blurRadius: 20,
                ),
              ],
            ),
            width: 600,
            height: 600,            
            padding:EdgeInsets.all(25),// Add padding to the container
            
            child: ListView()
          )
        ),
      ),
    );
  }
}