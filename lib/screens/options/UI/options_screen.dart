import 'package:flutter/material.dart';
import 'package:tier_birthday/core/theme/styled_text.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: StyledText('Options Page')),
    );
  }
}
