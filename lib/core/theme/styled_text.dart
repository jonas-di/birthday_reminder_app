import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonoFontText extends StatelessWidget {
  final String text;
  final double fontSize;
  const MonoFontText(this.text, {super.key, this.fontSize = 36});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.azeretMono(fontSize: fontSize));
  }
}

class StyledText extends StatelessWidget {
  final String text;
  final Color color;
  const StyledText(this.text, {super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.permanentMarker(fontSize: 20, color: color),
    );
  }
}
