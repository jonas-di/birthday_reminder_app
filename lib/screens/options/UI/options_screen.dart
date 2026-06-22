import 'package:flutter/material.dart';
import 'package:tier_birthday/core/widgets/primary_button.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            PrimaryButton(
              onPressed: () {},
              text: 'Press me',
              icon: Icon(Icons.add),
            ),
            PrimaryButton(onPressed: () {}, text: 'Press me'),
          ],
        ),
      ),
    );
  }
}
