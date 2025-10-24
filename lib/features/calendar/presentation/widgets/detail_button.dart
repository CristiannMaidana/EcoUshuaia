import 'package:flutter/material.dart';

class DetailButton extends StatelessWidget{
  final VoidCallback onPressed;

  const DetailButton({
    super.key,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            const Icon(Icons.arrow_drop_down_sharp, color: Colors.black, size: 30),
            Text("Detalle de fecha", style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  } 
}