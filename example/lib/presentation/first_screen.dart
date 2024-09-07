// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    const value = '';
    return Column(
      children: [
        const Text(
          "first text from screen 1",
          style: TextStyle(),
        ),
        const Text('second text from screen 1'),
        const Text('third text from screen 1'),
        const Text(
          '$value',
        ),
        const Text(
          value,
        ),
        const Text(
          value,
          style: TextStyle(),
        ),
        RichText(text: const TextSpan(children: [TextSpan(text: 'Richtext')])),
        const Text('''This is a long text
that spans across multiple lines
using triple quotes''')
      ],
    );
  }
}
