import 'package:flutter/widgets.dart';
import 'package:tier_birthday/core/theme/styled_text.dart';

class ScrollWheel extends StatelessWidget {
  final int initialItem;
  final List<String> items;
  final Function(int) onChange;
  const ScrollWheel({
    super.key,
    required this.items,
    required this.onChange,
    this.initialItem = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      controller: FixedExtentScrollController(initialItem: initialItem),
      physics: FixedExtentScrollPhysics(),
      overAndUnderCenterOpacity: 0.5,
      itemExtent: 50,
      perspective: 0.01,

      onSelectedItemChanged: (int value) => onChange(value + 1),
      children: [for (String item in items) MonoFontText(item)],
    );
  }
}
