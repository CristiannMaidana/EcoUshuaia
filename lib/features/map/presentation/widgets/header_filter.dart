import 'package:flutter/material.dart';

class HeaderFilter extends StatelessWidget{
  
  const HeaderFilter ({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [],
            ),
          ),
        ),
      ],
    );
  }
}