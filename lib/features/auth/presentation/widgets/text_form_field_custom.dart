import 'package:flutter/material.dart';

typedef StringValidator = String? Function(String?);

class TextFormFieldDataUser extends StatelessWidget {
  final GlobalKey<FormFieldState>? fieldKey;
  final Widget? prefixIcon;
  final StringValidator? validate;
  final String? titulo;
  final String labelText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry contentPadding;
  final bool obscureText;
  final VoidCallback? onTap;

  const TextFormFieldDataUser({
    super.key,
    this.fieldKey,
    this.prefixIcon,
    this.validate,
    this.titulo,
    required this.labelText,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
    this.obscureText = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titulo == null
              ? const SizedBox.shrink()
              : Text(
                  titulo!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
          TextFormField(
            key: fieldKey,
            controller: controller,
            focusNode: focusNode,
            style: Theme.of(context).textTheme.labelMedium,
            obscureText: obscureText,
            onTap: onTap,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: labelText,
              contentPadding: contentPadding,
              labelStyle: Theme.of(context).textTheme.labelLarge,
              errorStyle: Theme.of(context).textTheme.labelSmall,
              prefixIcon: prefixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: prefixIcon,
                    ),
            ),
            validator: validate,
          ),
        ],
      ),
    );
  }
}
