
import 'marked_date.dart';
import 'package:flutter/material.dart';

class MultipleMarkedDates{
  List<MarkedDate> markedDates;

  MultipleMarkedDates({required this.markedDates});

  void add(MarkedDate markedDate){
      markedDates.add(markedDate);
  }

  void addAll(List<MarkedDate> markedDates){
      this.markedDates.addAll(markedDates);
  }

  bool remove(MarkedDate markedDate){
    return markedDates.remove(markedDate);
  }

  void clear() {
    markedDates.clear();
  }

  bool isMarked(DateTime date){
    final results = markedDates.firstWhere((element) => element.date == date, orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.date.year == date.year;
  }

  Color getColor(DateTime date){
    final results = markedDates.firstWhere((element) => element.date == date, orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.color;
  }

  DateTime getDate(DateTime date){
    final results = markedDates.firstWhere((element) => element.date == date, orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.date;
  }

  TextStyle? getTextStyle(DateTime date){
    final results = markedDates.firstWhere((element) => element.date == date, orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)));
    return results.textStyle;
  }



}