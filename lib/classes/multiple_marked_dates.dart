import 'marked_date.dart';
import 'package:flutter/material.dart';

class MultipleMarkedDates {
  List<MarkedDate> markedDates;

  MultipleMarkedDates({required this.markedDates});

  void add(MarkedDate markedDate) {
    markedDates.add(markedDate);
  }

  void addRange(MarkedDate markedDate, {int plus = 0, int minus = 0}) {
    this.add(markedDate);

    if (plus > 0) {
      int start = 1;
      MarkedDate newAddMarkedDate;

      while (start <= plus) {
        newAddMarkedDate = new MarkedDate(
          color: markedDate.color,
          date: markedDate.date.add(Duration(days: start)),
          textStyle: markedDate.textStyle,
        );

        this.add(newAddMarkedDate);

        start += 1;
      }
    }

    if (minus > 0) {
      int start = 1;
      MarkedDate newSubMarkedDate;

      while (start <= minus) {
        newSubMarkedDate = new MarkedDate(
          color: markedDate.color,
          date: markedDate.date.subtract(Duration(days: start)),
          textStyle: markedDate.textStyle,
        );

        this.add(newSubMarkedDate);

        start += 1;
      }
    }
  }

  void addAll(List<MarkedDate> markedDates) {
    this.markedDates.addAll(markedDates);
  }

  bool remove(MarkedDate markedDate) {
    return markedDates.remove(markedDate);
  }

  void clear() {
    markedDates.clear();
  }

  bool isMarked(DateTime date) {
    final results = markedDates.firstWhere((element) => element.date == date,
        orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.date.year == date.year;
  }

  Color getColor(DateTime date) {
    final results = markedDates.firstWhere((element) => element.date == date,
        orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.color;
  }

  DateTime getDate(DateTime date) {
    final results = markedDates.firstWhere((element) => element.date == date,
        orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.date;
  }

  TextStyle? getTextStyle(DateTime date) {
    final results = markedDates.firstWhere((element) => element.date == date,
        orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.textStyle;
  }
}
