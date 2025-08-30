import 'package:flutter/material.dart';

typedef StringValidator = String? Function(String?);

class TextFormFieldDataUser extends StatefulWidget{
  final Widget? lottie;
  final StringValidator? validate;
  final String nombre;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  TextFormFieldDataUser({
    Key ? key,
    required this.lottie,
    required this.validate,
    required this.nombre,
    required this.focusNode,
    this.controller,
  }): super(key: key);

  @override
  State<TextFormFieldDataUser> createState() => _TextFormFieldDataUserState();
}

class _TextFormFieldDataUserState extends State<TextFormFieldDataUser> {
  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.nombre, style: Theme.of(context).textTheme.bodyLarge),
          TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            decoration: InputDecoration(
              labelText: widget.nombre,
              contentPadding: EdgeInsets.all(13),
              labelStyle: Theme.of(context).textTheme.labelLarge,
              errorStyle: Theme.of(context).textTheme.labelSmall,
              prefixIcon: widget.lottie == null ? null : Padding(
                padding: EdgeInsets.only(left: 12),
                child: widget.lottie,
              ),
            ),
            validator: widget.validate,
          ),
        ],
      ),
    );
  }
} 