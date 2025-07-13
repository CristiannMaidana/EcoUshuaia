import 'package:flutter/material.dart';
import 'package:eco_ushuaia/utils/validators_login.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              fontWeight: FontWeight.bold,
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
            
            child: ListView(
              children: <Widget>[
                SizedBox(height: 10), // Add space at the top
                Text('Ingrese en su cuenta',
                  style: TextStyle(
                    color: Color.fromRGBO(233, 233, 240, 1),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1.35),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 26), // Add space between text and text fields
                // Form for email 
                Form(
                  key: _formKey,
                  //TextField for email
                  child: TextFormField(
                    style: TextStyle(
                      color:Color.fromRGBO(28, 28, 30, 1),
                      fontSize: 14, 
                    ),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never, // To keep the label always invisible
                      contentPadding: EdgeInsets.all(20),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Color(0xFF202020), width: 1),
                      ),
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(108, 108, 112, 1),
                        fontSize: 20,
                        ),
                      fillColor: Color.fromRGBO(235, 235, 240, 1),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.blue.shade200, // azul brillante
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.red.shade200, // rojo para error
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: Colors.red.shade200, // rojo para error
                          width: 1.5,
                        ),
                      ),
                      errorStyle: TextStyle(
                        fontSize: 12, 
                      ),
                      errorMaxLines: 10,
                    ),
                    validator: validarEmail,
                  ),
                ),
                SizedBox(height: 26), // Add space between text fields
             ],
            )
          )
        ),
      ),
    );
  }
}