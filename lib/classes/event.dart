import 'package:flutter/material.dart';

class Event {
  final DateTime date;
  final String title;
  final Widget icon;

  Event({this.date, this.title, this.icon}) : assert(date != null);

  @override
  bool operator ==(dynamic other) {
    return this.date == other.date &&
        this.title == other.title &&
        this.icon == other.icon;
  }

  @override
  int get hashCode => hashValues(date, title, icon);
}
