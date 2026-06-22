import 'package:flutter/material.dart';
import 'package:tier_birthday/core/theme/colors.dart';
import 'package:tier_birthday/core/theme/styled_text.dart';
import 'package:tier_birthday/core/widgets/scroll_wheel.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late final DateTime today;

  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  final List<String> days = List.generate(
    31,
    (index) => (index + 1).toString(),
  );
  final List<String> months = const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mai',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Okt',
    'Nov',
    'Dez',
  ];
  late final List<String> years;

  @override
  void initState() {
    today = DateTime.now();
    selectedDay = today.day - 1;
    selectedMonth = today.month - 1;
    selectedYear = today.year - 1;

    years = List.generate(
      today.year - 1900,
      (index) => (1900 + index + 1).toString(),
    );
    super.initState();
  }

  void onChangeDay(int value) => selectedDay = value;
  void onChangeMonth(int value) => selectedMonth = value;
  void onChangeYear(int value) => selectedYear = value + 1900;

  @override
  Widget build(BuildContext context) {
    return Container(
      //size
      height: 140,
      width: 350,
      padding: EdgeInsets.all(4),

      decoration: BoxDecoration(
        //border
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: BoxBorder.all(color: AppColor.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ScrollWheel(
              items: days,
              onChange: onChangeDay,
              initialItem: selectedDay,
            ),
          ),

          MonoFontText('-'),
          Expanded(
            child: ScrollWheel(
              items: months,
              onChange: onChangeMonth,
              initialItem: selectedMonth,
            ),
          ),
          MonoFontText('-'),
          Expanded(
            child: ScrollWheel(
              items: years,
              onChange: onChangeYear,
              initialItem: selectedYear,
            ),
          ),
        ],
      ),
    );
  }
}
