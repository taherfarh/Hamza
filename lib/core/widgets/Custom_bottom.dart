// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';

class Custom_Bottom extends StatelessWidget {
  const Custom_Bottom(
      {super.key, required this.function, required this.widget});
  final Widget widget;
  final Function() function;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(Color.fromARGB(255, 2, 146, 131)),
          minimumSize: MaterialStatePropertyAll(Size(double.infinity, 50)),
        ),
        onPressed: function,
        child: widget);
  }
}
