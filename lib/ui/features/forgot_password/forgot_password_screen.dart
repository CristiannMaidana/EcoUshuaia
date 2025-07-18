import 'package:eco_ushuaia/ui/core/themes/container_decoration_theme.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_Button.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_SizedBox.dart';
import 'package:eco_ushuaia/ui/features/otp_code/otp_screen.dart';
import 'package:eco_ushuaia/utils/validators_forgot_password.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Nueva variable de estado para saber si está en modo email o celular
  bool _esCelular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EcoUshuaia', style: Theme.of(context).textTheme.displayLarge),
      ),
      body: Center(
        child: Column(
          children: [
            espacioVerticalMediano,
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              width: 400,
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Olvido contraseña', 
                    style: Theme.of(context).textTheme.headlineMedium
                  ),
                  Text(
                    _esCelular ? 'Ingrese el celular con el que se registro abajo para que pueda ser enviado el codigo de verificación.' : 'Ingrese el mail con el que se registro abajo para que pueda ser enviado el codigo de verificación.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            espacioVerticalMediano,
            Container(
              decoration: containerInputsLogin,
              width: 400,
              height: 300,
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _esCelular ? "Celular" : "Email", 
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: _esCelular ? 'Ingrese un número' : 'Ingrese un mail',
                        labelStyle: Theme.of(context).textTheme.labelLarge,
                        errorStyle: Theme.of(context).textTheme.labelSmall
                      ),
                      validator: _esCelular ? validarCelular : validarEmailPassword,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _esCelular = !_esCelular; // Cambia entre email y celular
                      });
                    },
                    child: Text(_esCelular ? 'Cambiar a email' : 'Cambiar a celular'),
                  ),
                  BotonEstandar(
                    texto: 'Siguiente',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _esCelular ? '¡Numero enviado!':'¡Mail enviado!', 
                              style: Theme.of(context).textTheme.labelLarge, 
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.white, // Opcional: color de fondo
                          ),
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
                      }
                    },
                    width: 150,
                    height: 54,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
