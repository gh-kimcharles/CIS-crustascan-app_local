import 'package:flutter/material.dart';

class RegisterTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String textInput;
  final IconData iconInput;
  final String hintTextInput;
  final String? Function(String?)? validator;
  final bool isValidationIcon;

  const RegisterTextFormField({
    super.key,
    this.controller,
    required this.textInput,
    required this.iconInput,
    required this.hintTextInput,
    this.validator,
    required this.isValidationIcon,
  });

  @override
  State<RegisterTextFormField> createState() => _RegisterTextFormFieldState();
}

class _RegisterTextFormFieldState extends State<RegisterTextFormField> {
  bool? isValid;

  void _validateRegister(String? value) {
    // use the validator to check
    final result = widget.validator?.call(value);
    setState(() {
      isValid = result == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(widget.textInput, style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: widget.controller,
          onChanged: _validateRegister,
          validator: (value) {
            final result = widget.validator?.call(value);
            isValid = result == null;
            return result;
          },
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 20, right: 5),
              child: Icon(widget.iconInput),
            ),
            suffixIcon: !widget.isValidationIcon || isValid == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Icon(
                      size: 18,
                      isValid! ? Icons.check_circle : Icons.error,
                      color: isValid!
                          ? const Color.fromARGB(255, 54, 143, 57)
                          : const Color.fromARGB(255, 212, 53, 41),
                    ),
                  ),
            filled: true,
            fillColor: Colors.grey.shade200,
            hintText: widget.hintTextInput,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
    );
  }
}
