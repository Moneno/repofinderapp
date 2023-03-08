import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SearchButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final bool correctInput;
  const SearchButton(
      {super.key, required this.onTap, this.correctInput = false});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
          shape: const CircleBorder(),
          color: correctInput ? Colors.lightBlue : Colors.grey),
      child: IconButton(
        padding: const EdgeInsets.all(20),
        onPressed: onTap,
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        iconSize: 35,
      ),
    );
  }
}
