import 'package:flutter/material.dart';

class InputFormField extends StatefulWidget {
  final String? labelText;
  final IconData? icon;
  final bool isSecret;
  final TextEditingController? controller;
  final EdgeInsetsGeometry margin;

  const InputFormField({
    super.key,
    this.labelText,
    this.icon,
    this.margin = EdgeInsets.zero,
    this.isSecret = false,
    this.controller,
  });

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  bool obscuredText = false;

  @override
  void initState() {
    super.initState();

    obscuredText = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: TextFormField(
        obscureText: obscuredText,
        controller: widget.controller,
        decoration: InputDecoration(
          isDense: true,
          labelText: widget.labelText,
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isSecret
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscuredText = !obscuredText;
                    });
                  },
                  icon: Icon(
                    obscuredText ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
        ),
      ),
    );
  }
}