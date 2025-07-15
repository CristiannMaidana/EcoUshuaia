import 'package:eco_ushuaia/ui/core/ui/custom_Button.dart';
import 'package:flutter/material.dart';
import 'package:eco_ushuaia/utils/validators_login.dart';
import 'package:eco_ushuaia/ui/core/themes/login_theme.dart';
import 'package:eco_ushuaia/ui/core/themes/container_decoration_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_SizedBox.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('EcoUshuaia', style: Theme.of(context).textTheme.displayLarge),),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(25), // Add padding to the body
        
        child: Container(
          decoration: containerInputsLogin,
          width: 600,
          height: 600,            
          padding:EdgeInsets.all(25),// Add padding to the container
          child: ListView(
            children: <Widget>[
              espacioVerticalMediano,
              Text('Ingrese en su cuenta', style: Theme.of(context).textTheme.headlineLarge),
              espacioVerticalMediano,
              // Form for email 
              Form(
                key: _formKey,
                //TextField for email
                child: Column(
                  children: [
                    TextFormField(
                      style: Theme.of(context).textTheme.labelMedium,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: Theme.of(context).textTheme.labelLarge,
                        errorStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                      validator: validarEmail,
                    ),
                    espacioVerticalMediano,
                    TextFormField(
                      style: Theme.of(context).textTheme.labelMedium,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: Theme.of(context).textTheme.labelLarge,
                        errorStyle: Theme.of(context).textTheme.labelSmall,
                      ),
                      validator: validarPassword,
                    ),
                    espacioVerticalMediano,
                  ],
                )              
              ),
              //Alineo en el medio al boton
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BotonEstandar(
                    texto: "Aceptar",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Todos los campos validaron OK
                        // Podés continuar con el envío o acción
                      } else {
                        // Algún campo no pasó la validación
                      }
                    },
                    width: 150,
                    height: 54,
                  ),
                ],
              ),
            ],
          )
        )
      ),
    );
  }
}