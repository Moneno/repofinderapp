import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchTextField extends StatelessWidget {
  final VoidCallback? onSubmitted;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  const SearchTextField({
    super.key,
    this.onChanged,
    this.errorText,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (value) {
        onSubmitted?.call();
      },
      style: GoogleFonts.openSans(),
      decoration: InputDecoration(
        hintText: 'Repository Name',
        filled: true,
        fillColor: const Color.fromRGBO(211, 211, 211, 0.5),
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 15),
        border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
      onChanged: onChanged,
    );
  }
}
