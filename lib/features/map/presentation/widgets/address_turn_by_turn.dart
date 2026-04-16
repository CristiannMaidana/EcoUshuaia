import 'package:flutter/material.dart';

class AddressTurnByTurn extends StatefulWidget{

  const AddressTurnByTurn({
    super.key,
  });

  @override
  State<AddressTurnByTurn> createState() => _AddressTurnByTurnState();
}

class _AddressTurnByTurnState extends State<AddressTurnByTurn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12, offset: Offset(0, 4))],
      ),
    );
  }
}