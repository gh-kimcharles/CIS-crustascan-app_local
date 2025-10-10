import 'package:flutter/material.dart';

class CustomPasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final IconData? icon;
  final String hintText;
  final String? Function(String?)? validator;

  const CustomPasswordFormField({
    super.key,
    required this.controller,
    required this.text,
    this.icon,
    required this.hintText,
    this.validator,
  });

  @override
  State<CustomPasswordFormField> createState() =>
      _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.text, style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          obscureText: _isPasswordHidden,
          validator: widget.validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 20),
            prefixIcon: widget.icon != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 5,
                      top: 15,
                      bottom: 15,
                    ),
                    child: Icon(widget.icon),
                  )
                : null,
            filled: true,
            fillColor: const Color.fromARGB(255, 247, 247, 247),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
