import 'package:flutter/material.dart';

class EditUserScreen extends StatefulWidget{

  const EditUserScreen({
    Key ? key,
  }): super(key: key);

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> with SingleTickerProviderStateMixin{

  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(),
    );
  }
}