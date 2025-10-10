import 'dart:async';
import 'package:flutter/material.dart';

class EditProfileTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String textInput;
  final String hintText;
  final String? Function(String?)? validator;

  const EditProfileTextFormField({
    super.key,
    this.controller,
    required this.textInput,
    required this.hintText,
    this.validator,
  });

  @override
  State<EditProfileTextFormField> createState() =>
      _EditProfileTextFormFieldState();
}

class _EditProfileTextFormFieldState extends State<EditProfileTextFormField> {
  bool? isValid;
  bool isShowSuffixIcon = false;
  bool hasTyped = false;
  Timer? timer;

  void _validateSaveChanges(String? value) {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.textInput, style: TextStyle(fontSize: 12)),
        SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          onChanged: _validateSaveChanges,
          validator: (value) {
            final result = widget.validator?.call(value);
            isValid = result == null;
            return result;
          },
          decoration: InputDecoration(
            // filled: true,
            fillColor: Colors.grey.shade100,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            prefixIcon: Icon(Icons.edit_rounded),
            suffixIcon: !hasTyped
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
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 114, 22, 26),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
