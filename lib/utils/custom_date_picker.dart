import 'package:casarancha/resources/color_resources.dart';
import 'package:casarancha/resources/localization_text_strings.dart';
import 'package:casarancha/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../resources/image_resources.dart';
import '../widgets/text_widget.dart';

enum PickerDateComponent { day, month, year }

class CustomDatePicker extends StatefulWidget {
  List<bool> showSelected = [];
  Function dateChangedCallback;
  DateTime? getDateTime;
  final String? userDateTime;
  CustomDatePicker(
      {Key? key,
      required this.dateChangedCallback,
      required this.showSelected,
      this.getDateTime,
      this.userDateTime})
      : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime currentDate = DateTime.now().toLocal();
  String selectedDay = DateTime.now().day.toString();
  String selectedMonth = DateFormat.MMM().format(DateTime.now()).toString();
  String selectedYear = DateTime.now().year.toString();
  List<String> dateInMonthList = [];
  List<String> yearList = [];
  List<String> monthList = [];

  String convertDate({inputString, list}) {
    List<String> dateParts = inputString.split('-');

    if (list == 1) {
      return dateParts[0];
    } else if (list == 2) {
      return dateParts[1];
    } else {
      return dateParts[2];
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.getDateTime != null) {
      currentDate = widget.getDateTime!;
      selectedDay = currentDate.day.toString();
      selectedMonth = DateFormat.MMM().format(currentDate).toString();
      selectedYear = currentDate.year.toString();

      widget.dateChangedCallback(currentDate);
    }
  }

  int get daysInMonthConverter {
    return DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
  }

  @override
  void didUpdateWidget(covariant CustomDatePicker oldWidget) {
    if (widget.getDateTime != null) {
      currentDate = widget.getDateTime!;
      selectedDay = currentDate.day.toString();
      selectedMonth = DateFormat.MMM().format(currentDate).toString();
      selectedYear = currentDate.year.toString();

      widget.dateChangedCallback(currentDate);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return datePickerContainer();
  }

  Widget datePickerContainer() {
    return Row(
      children: [
        // Day
        _dates(PickerDateComponent.day),
        widthBox(7),
        // Month
        _dates(PickerDateComponent.month),
        widthBox(7),
        // Year
        _dates(PickerDateComponent.year),
      ],
    );
  }

  Widget _dates(PickerDateComponent comp) {
    generateDate();
    generateMonth();
    generateYear();
    return Expanded(
      child: Container(
          height: 60.h,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
              color: colorFF3, borderRadius: BorderRadius.circular(16.0)),
          // border: Border.all(color: colorF73 ),
          child: comp == PickerDateComponent.day
              ? _dropDowns(
                  dymList: dateInMonthList,
                  hint: strDay,
                  onChanged: (val) {
                    setState(() {
                      selectedDay = val;
                      widget.showSelected[0] = true;
                      currentDate = DateTime(
                          int.parse(selectedYear),
                          monthList.indexOf(selectedMonth) + 1,
                          int.parse(selectedDay));
                      widget.dateChangedCallback(currentDate);
                    });
                  },
                  buttonValue: widget.showSelected[0]
                      ? selectedDay
                      : convertDate(inputString: widget.userDateTime, list: 1))
              : comp == PickerDateComponent.month
                  ? _dropDowns(
                      hint: strMonth,
                      dymList: monthList,
                      onChanged: (val) {
                        setState(() {
                          selectedMonth = val;
                          widget.showSelected[1] = true;
                          int valMonthDays = _daysInMonthConverter(DateTime(
                              int.parse(selectedYear),
                              monthList.indexOf(selectedMonth) + 2,
                              0));

                          if (valMonthDays < int.parse(selectedDay)) {
                            currentDate = DateTime(int.parse(selectedYear),
                                monthList.indexOf(val!) + 1, valMonthDays);
                            selectedDay = valMonthDays.toString();
                          } else {
                            currentDate = DateTime(
                                int.parse(selectedYear),
                                monthList.indexOf(val!) + 1,
                                int.parse(selectedDay));
                          }
                          widget.dateChangedCallback(currentDate);
                        });
                      },
                      buttonValue: widget.showSelected[1]
                          ? selectedMonth
                          : convertDate(
                              inputString: widget.userDateTime, list: 2))
                  : _dropDowns(
                      dymList: yearList,
                      hint: strYear,
                      onChanged: (val) {
                        setState(() {
                          selectedYear = val;
                          widget.showSelected[2] = true;
                          int valMonthDays = _daysInMonthConverter(DateTime(
                              int.parse(selectedYear),
                              monthList.indexOf(selectedMonth) + 2,
                              0));

                          if (valMonthDays < int.parse(selectedDay)) {
                            currentDate = DateTime(
                                int.parse(selectedYear),
                                monthList.indexOf(selectedMonth) + 1,
                                valMonthDays);
                            selectedDay = valMonthDays.toString();
                          } else {
                            currentDate = DateTime(
                                int.parse(selectedYear),
                                monthList.indexOf(selectedMonth) + 1,
                                int.parse(selectedDay));
                          }
                          widget.dateChangedCallback(currentDate);
                        });
                      },
                      buttonValue: widget.showSelected[2]
                          ? selectedYear
                          : convertDate(
                              inputString: widget.userDateTime, list: 3))),
    );
  }

  // bool isLeapYear(int year) =>
  //     (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  Widget _dropDowns(
      {ValueChanged? onChanged,
      required List dymList,
      String? hint,
      required String? buttonValue}) {
    return DropdownButton(
      menuMaxHeight: 250.h,
      value: buttonValue,
      isExpanded: true,
      hint: TextWidget(
        text: hint.toString(),
        fontSize: 14.sp,
        color: color080,
        fontWeight: FontWeight.w400,
      ),
      items: dymList.map((value) {
        return DropdownMenuItem(
          alignment: Alignment.center,
          value: value,
          child: TextWidget(
            text: value.toString(),
            fontSize: 14.sp,
            color: color080,
            fontWeight: FontWeight.w400,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      icon: Align(
          alignment: Alignment.centerRight,
          child: SvgPicture.asset(icDropDown)),
      iconSize: 42,
      underline: const SizedBox(),
    );
  }

  int _daysInMonthConverter(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  generateDate() {
    dateInMonthList.clear();
    for (int i = 1; i <= _daysInMonthConverter(currentDate); i++) {
      dateInMonthList.add(i.toString());
    }
  }

  generateMonth() {
    monthList.clear();
    for (int i = 1; i <= 12; i++) {
      DateTime lastDayOfMonth = DateTime(0, i + 1, 0);
      monthList.add(DateFormat.MMM().format(lastDayOfMonth));
    }
  }

  generateYear() {
    yearList.clear();
    for (int i = DateTime.now().year; i >= DateTime.now().year - 100; i--) {
      yearList.add(i.toString());
    }
  }
}
