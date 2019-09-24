import 'package:flutter/material.dart';

class Event implements EventInterface {
  final DateTime date;
  final String title;
  final Widget icon;
  final Widget dot;

  Event({
    this.date,
    this.title,
    this.icon,
    this.dot,
  }) : assert(date != null);

  @override
  bool operator ==(dynamic other) {
    return this.date == other.date &&
        this.title == other.title &&
        this.icon == other.icon &&
        this.dot == other.dot;
  }

  @override
  int get hashCode => hashValues(date, title, icon);

  @override
  DateTime getDate() {
    return date;
  }

  @override
  Widget getDot() {
    return dot;
  }

  @override
  Widget getIcon() {
    return icon;
  }

  @override
  String getTitle() {
    return title;
  }
}

abstract class EventInterface {
  DateTime getDate();
  String getTitle();
  Widget getIcon();
  Widget getDot();
}
