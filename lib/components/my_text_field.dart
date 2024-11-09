import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final double borderRadius;
  const MyTextField({
    super.key,
    this.suffixIcon,
    this.hintText,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorRadius: const Radius.circular(100.0),
      cursorColor: Theme.of(context).colorScheme.inverseSurface,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
  }
}
