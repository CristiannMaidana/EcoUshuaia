import 'package:eco_ushuaia/ui/core/ui/custom_Button.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_SizedBox.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_lottie/custom_avatar.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_lottie/custom_eye_password.dart';
import 'package:eco_ushuaia/ui/core/ui/custom_lottie/custom_email.dart';
import 'package:eco_ushuaia/ui/features/login/login_screen.dart';
import 'package:eco_ushuaia/utils/validator_singup_screen/validators_singup.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget{
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();    final FocusNode _userFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordTwo = true; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear cuenta'),
        titleTextStyle: Theme.of(context).textTheme.displayLarge,
      ),
      body: Center(
        child: Column(
          children: [
            // Formulario deslizable
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Input Datos personales
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          espacioVerticalMediano,
                          Container(
                            margin: EdgeInsets.all(25),
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text('Nombre', style: Theme.of(context).textTheme.bodyLarge),
                                            TextFormField(
                                              focusNode: _userFocusNode,
                                              decoration: InputDecoration(
                                                labelText: 'Nombre',
                                                contentPadding: EdgeInsets.all(13),
                                                labelStyle: Theme.of(context).textTheme.labelLarge,
                                                errorStyle: Theme.of(context).textTheme.labelSmall,
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(left: 12),
                                                  child: CustomAvatar(focusNode: _userFocusNode),
                                                ),
                                              ),
                                              validator: nombreValidator,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Text('Apellido', style: Theme.of(context).textTheme.bodyLarge),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Apellido',
                                                contentPadding: EdgeInsets.all(13),
                                                labelStyle: Theme.of(context).textTheme.labelLarge,
                                                errorStyle: Theme.of(context).textTheme.labelSmall,
                                              ),
                                              validator: apellidoValidator,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                espacioVerticalMediano,

                                Text('Email', style: Theme.of(context).textTheme.bodyLarge,),
                                SizedBox(
                                  child: TextFormField(
                                    focusNode: _emailFocusNode,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      contentPadding: EdgeInsets.all(13),
                                      labelStyle: Theme.of(context).textTheme.labelLarge,
                                      errorStyle: Theme.of(context).textTheme.labelSmall,
                                      prefixIcon: Padding(
                                        padding: EdgeInsetsGeometry.only(left: 12),
                                        child: CustomEmail(focusNode: _emailFocusNode,),
                                      ),
                                    ),
                                    validator: emailNuevoValidator,
                                  ),
                                ),
                                espacioVerticalMediano,

                                Text('Contraseña', style: Theme.of(context).textTheme.bodyLarge,),
                                SizedBox(
                                  child: TextFormField(
                                    controller: passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      labelText: 'Contraseña',
                                      contentPadding: EdgeInsets.all(13),
                                      labelStyle: Theme.of(context).textTheme.labelLarge,
                                      errorStyle: Theme.of(context).textTheme.labelSmall,
                                      prefixIcon: Padding(
                                        padding: EdgeInsetsGeometry.only(left: 12),
                                          child: CustomEyePassword(
                                            isClosed: _obscurePassword,// true=cerrado, false = abierto
                                            onTap: () {
                                              setState(() {
                                                _obscurePassword = !_obscurePassword;
                                              });
                                            },
                                          )
                                        )
                                    ),
                                    validator: contrasennaValidator,
                                  ),
                                ),                        
                                espacioVerticalMediano,

                                Text('Repetir contraseña', style: Theme.of(context).textTheme.bodyLarge,),
                                SizedBox(
                                  child: TextFormField(
                                    obscureText: _obscurePasswordTwo,
                                    decoration: InputDecoration(
                                      labelText: 'Repita contraseña',
                                      contentPadding: EdgeInsets.all(13),
                                      labelStyle: Theme.of(context).textTheme.labelLarge,
                                      errorStyle: Theme.of(context).textTheme.labelSmall,
                                      prefixIcon: Padding(
                                        padding: EdgeInsetsGeometry.only(left: 12),
                                        child: CustomEyePassword(
                                          isClosed: _obscurePasswordTwo,
                                           onTap: () {
                                            setState(() {
                                              _obscurePasswordTwo = !_obscurePasswordTwo;
                                            });
                                           }
                                        ),
                                      )
                                    ),
                                    validator: (value) => repetirContrasennaValidator(value, passwordController.text)
                                  ),
                                ),                 
                                espacioVerticalMediano,

                                BotonEstandar(
                                  texto: 'Registrarse',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()){}
                                  },
                                ),
                                espacioVerticalMediano,
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Ya tiene una cuenta?', style: Theme.of(context).textTheme.labelMedium,),
                                    TextButton(onPressed: (){
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginScreen()),
                                        (route) => false,
                                      );
                                    },
                                      child: Text('Ingresar', style: Theme.of(context).textTheme.labelMedium,)
                                    ),
                                  ],
                                ),              
                                espacioVerticalMediano,

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('O ingrese con', style: Theme.of(context).textTheme.labelMedium,)
                                  ]
                                ),
  
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(onPressed: null, icon: Icon(Icons.logo_dev), iconSize: 70),
                                    IconButton(onPressed: null, icon: Icon(Icons.logo_dev), iconSize: 70),
                                    IconButton(onPressed: null, icon: Icon(Icons.logo_dev), iconSize: 70)
                                  ],
                                ),
                              ]
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}