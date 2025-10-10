import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;
  final bool showClear;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.showClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Search for...",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 5),
            child: Icon(Icons.search),
          ),
          suffixIcon: showClear
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey.shade600),
                    onPressed: onClear,
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
