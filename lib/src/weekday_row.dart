import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/src/default_styles.dart'
    show defaultWeekdayTextStyle;
import 'package:intl/intl.dart';

enum WeekdayFormat {
  weekdays,
  standalone,
  short,
  standaloneShort,
  narrow,
  standaloneNarrow,
}

class WeekdayRow extends StatelessWidget {
  WeekdayRow(this.dateFormant, this.showWeekdays, this.weekdayFormat,
      this.weekDayMargin, this.weekdayTextStyle, this.localeDate);

  final bool showWeekdays;
  final DateFormat dateFormant;
  final int firstDayOfWeek = 0;
  final WeekdayFormat weekdayFormat;
  final EdgeInsets weekDayMargin;
  final TextStyle weekdayTextStyle;
  final DateFormat localeDate;

  Widget _weekdayContainer(String weekDay) => Expanded(
          child: Container(
        margin: weekDayMargin,
        child: Center(
          child: DefaultTextStyle(
            style: defaultWeekdayTextStyle,
            child: Text(
              weekDay,
              style: weekdayTextStyle,
            ),
          ),
        ),
      ));

  List<Widget> _generateWeekDays() {
    switch (weekdayFormat) {
      case WeekdayFormat.weekdays:
        {
          return localeDate.dateSymbols.WEEKDAYS
              .map<Widget>((day) => _weekdayContainer(day));
        }
      case WeekdayFormat.standalone:
        {
          return localeDate.dateSymbols.STANDALONEWEEKDAYS
              .map<Widget>((day) => _weekdayContainer(day));
        }
      case WeekdayFormat.short:
        {
          return localeDate.dateSymbols.SHORTWEEKDAYS
              .map<Widget>((day) => _weekdayContainer(day));
        }
      case WeekdayFormat.standaloneShort:
        {
          return localeDate.dateSymbols.STANDALONESHORTWEEKDAYS
              .map<Widget>((day) => _weekdayContainer(day));
        }
      case WeekdayFormat.narrow:
        {
          return localeDate.dateSymbols.NARROWWEEKDAYS
              .map<Widget>((day) => _weekdayContainer(day));
        }
      case WeekdayFormat.standaloneNarrow:
        {
          return localeDate.dateSymbols.STANDALONENARROWWEEKDAYS
              .map<Widget>((day) => _weekdayContainer(day));
        }
      default:
        {
          return localeDate.dateSymbols.STANDALONEWEEKDAYS
              .map<Widget>((day) => _weekdayContainer(day));
        }
    }
  }

  @override
  Widget build(BuildContext context) => showWeekdays
      ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _generateWeekDays(),
        )
      : Container();
}
