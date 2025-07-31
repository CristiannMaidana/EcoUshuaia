import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomNotification extends StatefulWidget{
  final double size;
  final FocusNode focusNode;

  const CustomNotification({
    Key? key,
    this.size = 70,
    required this.focusNode,
  }) : super(key: key);
}