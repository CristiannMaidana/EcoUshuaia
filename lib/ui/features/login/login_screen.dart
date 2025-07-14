import 'package:eco_ushuaia/ui/core/themes/colores_theme.dart';
import 'package:flutter/material.dart';
import 'package:eco_ushuaia/utils/validators_login.dart';
import 'package:eco_ushuaia/ui/core/themes/login_theme.dart';

void main() {
  runApp(MaterialApp(
    theme: appLoginTheme, 
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
    return  Scaffold(
        appBar: AppBar(title: Text('EcoUshuaia', style: Theme.of(context).textTheme.displayLarge),),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(25), // Add padding to the body
          
          child: Container(
            decoration: BoxDecoration(
              color: verdeLoginContainer,
              borderRadius: BorderRadius.circular(50), // Rounded corners
              border: Border.all(
                color: Color.fromRGBO(10, 20, 13, 0.498),
                width: 1, // Border width
              ),
              boxShadow: [
                BoxShadow(
                  color: sombraNegro,
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
                  child: TextFormField(
                    style: Theme.of(context).textTheme.labelMedium,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: Theme.of(context).textTheme.labelLarge,
                      errorStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                    validator: validarEmail,
                  ),
                ),
                SizedBox(height: 26), // Add space between text fields
             ],
            )
          )
        ),
    );
  }
}