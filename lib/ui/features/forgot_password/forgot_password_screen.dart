import 'package:eco_ushuaia/ui/core/themes/container_decoration_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_Button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  //const ForgotPasswordScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olvido contraseña'),
      ),
      body: Center(
        child: Container(
          decoration: containerInputsLogin,
          width: 400,
          height: 300,
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email", style: Theme.of(context).textTheme.headlineLarge,),
              Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Ingrese un mail',
                    labelStyle: Theme.of(context).textTheme.labelLarge,
                    errorStyle: Theme.of(context).textTheme.labelSmall
                  ),
                ),
              ),
              TextButton(
                onPressed: (){
                  //Aca tiene que estar el metodo que haga que cambie el nombre de Email a celular,
                },
                child: Text('Cambiar a celular')
              ),
              BotonEstandar(
                texto: 'Siguiente',
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
          )
        ),
      ),
    );
  }
}
