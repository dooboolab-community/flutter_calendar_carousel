import 'package:flutter/material.dart';

class Event implements EventInterface {
  final DateTime date;
  final String title;
  final String description;
  final Widget icon;
  final Widget dot;
  final Color color;

  Event({
    this.date,
    this.title,
    this.icon,
    this.dot,
    this.description, 
    this.color
  }) : assert(date != null);

  @override
  bool operator ==(dynamic other) {
    return this.date == other.date &&
        this.title == other.title &&
        this.icon == other.icon &&
        this.dot == other.dot && 
        this.description == other.description && 
        this.color == other.color;
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

  @override
  String getDescription() {
    return description;
  }

  @override
  Color getColor() {
    return color;
  }
}

abstract class EventInterface {
  DateTime getDate();
  String getTitle();
  Widget getIcon();
  Widget getDot();
  Color getColor();
  String getDescription();
}
