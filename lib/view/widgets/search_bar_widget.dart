import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String hint;
  final Function(String) onChanged;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    required this.hint,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        cursorColor: Colors.black,
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: hint,
          hintStyle:
              TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
