import 'package:flutter/material.dart';
import 'package:eco_ushuaia/utils/validators_login.dart';
import 'package:eco_ushuaia/ui/core/themes/texto_theme.dart';

void main() {
  runApp(MaterialApp(
    theme: appTextTheme,
    home: LoginScreen(),
  ));
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
          title: Text('EcoUshuaia', style: Theme.of(context).textTheme.displayLarge),
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
                SizedBox(height: 4), // Add space at the top
                Text('Ingrese en su cuenta', style: Theme.of(context).textTheme.headlineLarge),
                SizedBox(height: 26), // Add space between text and text fields
                // Form for email 
                Form(
                  key: _formKey,
                  //TextField for email
                  child: TextFormField(style: Theme.of(context).textTheme.labelMedium,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never, // To keep the label always invisible
                      contentPadding: EdgeInsets.all(20),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Color(0xFF202020), width: 1),
                      ),
                      labelStyle: Theme.of(context).textTheme.labelLarge,
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
                      errorStyle: Theme.of(context).textTheme.labelSmall,
                      errorMaxLines: 10,
                    ),
                    validator: validarEmail,
                  ),
                ),
                SizedBox(height: 26), // Add space between text fields
                

                // TextField for password
                TextField(
                  obscureText: true, // To hide the password input
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(25),
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Color(0xFF34C759), width: 1),
                    ),
                    labelStyle: TextStyle(color: Color(0xFF4A4A4A), fontSize: 20),
                    fillColor: Color(0xFFebebeb), // Light gray background
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),
                

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Todos los campos validaron OK
                      // Podés continuar con el envío o acción
                    } else {
                      // Algún campo no pasó la validación
                    }
                  },
                  child: Text('Aceptar'),
                ),
             ],
            )
          )
        ),
      ),
    );
  }
}