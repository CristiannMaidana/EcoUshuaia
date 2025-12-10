import 'package:flutter/material.dart';

class ContainerDetail extends StatefulWidget {
  final Container container;

  const ContainerDetail({
    Key? key,
    required this.container,
  }) : super(key: key);

  @override
  State<ContainerDetail> createState() => _ContainerDetailState();
}

class _ContainerDetailState extends State<ContainerDetail> {
  @override
  Widget build(BuildContext context) {
    return Stack();
  }
}