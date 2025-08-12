import 'package:flutter/material.dart';

import 'fonts_class.dart';

class TextView extends StatelessWidget {
  final String label;
  final String fontFamily;
  final double fontSize;

  const TextView({
    super.key,
    required this.label,
    this.fontFamily = Fonts.interSemiBold,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
      ),
    );
  }
}
