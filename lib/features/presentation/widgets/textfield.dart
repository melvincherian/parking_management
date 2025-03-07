// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'package:flutter/material.dart';

class SignupTextFormField extends StatefulWidget {
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;

  const SignupTextFormField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  _SignupTextFormFieldState createState() => _SignupTextFormFieldState();
}

class _SignupTextFormFieldState extends State<SignupTextFormField> {
  late ValueNotifier<bool> _obscureTextNotifier;

  @override
  void initState() {
    super.initState();
    _obscureTextNotifier = ValueNotifier(widget.obscureText);
  }
  
  @override
  void dispose() {
    _obscureTextNotifier.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    _obscureTextNotifier.value = !_obscureTextNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureTextNotifier,
      builder: (context, obscureText, child) {
        return TextFormField(
          controller: widget.controller,
          obscureText: obscureText,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            filled: true,
            fillColor: Colors.grey[100],
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                : null,
          ),
        );
      },
    );
  }
}
