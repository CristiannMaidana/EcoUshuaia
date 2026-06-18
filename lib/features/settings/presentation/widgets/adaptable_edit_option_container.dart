import 'package:flutter/material.dart';

class AdaptableEditOptionContainer extends StatelessWidget{
  final Widget child;
  final String screenTitle;

  const AdaptableEditOptionContainer({
    super.key,
    required this.child,
    required this.screenTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(screenTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: child,
      ),
    );
  }
}