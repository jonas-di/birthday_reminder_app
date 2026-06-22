import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tier_birthday/core/theme/colors.dart';
import 'package:tier_birthday/core/theme/styled_text.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Icon? icon;
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColor.primary),
      ),
      label: StyledText(text, color: AppColor.textBright),
      icon: icon,
    );
  }
}
