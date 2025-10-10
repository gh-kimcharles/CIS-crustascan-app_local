import 'dart:async';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String textInput;
  final IconData? iconInput;
  final String hintTextInput;
  final String? Function(String?)? validator;
  final bool isValidationIcon;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.textInput,
    this.iconInput,
    required this.hintTextInput,
    this.validator,
    required this.isValidationIcon,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool? isValid;
  bool isShowSuffixIcon = false;
  bool hasTyped = false;
  Timer? timer;

  void _validateRegister(String? value) {
    // User has typed something
    if (!hasTyped) {
      setState(() {
        hasTyped = true;
      });
    }

    // Cancel previous timer if typing continues
    timer?.cancel();

    setState(() {
      isShowSuffixIcon = false;
      isValid = null;
    });

    // Run validator
    final result = widget.validator?.call(value);
    final currentValid = result == null;

    // Delay 2 seconds, then show result
    timer = Timer(Duration(seconds: 1), () {
      setState(() {
        isValid = currentValid;
        isShowSuffixIcon = true;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
            return result;
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 20),
            prefixIcon: widget.iconInput != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 5,
                      top: 15,
                      bottom: 15,
                    ),
                    child: Icon(widget.iconInput),
                  )
                : null,
            suffixIcon: !widget.isValidationIcon || !hasTyped
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: isShowSuffixIcon
                        ? Icon(
                            size: 18,
                            isValid! ? Icons.check_circle : Icons.error,
                            color: isValid!
                                ? const Color.fromARGB(255, 54, 143, 57)
                                : const Color.fromARGB(255, 179, 43, 34),
                          )
                        : SizedBox(
                            width: 18,
                            height: 18,
                            child: Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                  ),
            filled: true,
            fillColor: const Color.fromARGB(255, 247, 247, 247),
            hintText: widget.hintTextInput,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
      ],
    );
  }
}
