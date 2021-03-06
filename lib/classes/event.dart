import 'package:flutter/material.dart';

class Event implements EventInterface {
  final DateTime date;
  final String? title;
  final Widget? icon;
  final Widget? dot;
  final int? id;
  Event({
    this.id,
    required this.date,
    this.title,
    this.icon,
    this.dot,
  });

  @override
  bool operator ==(dynamic other) {
    return this.date == other.date &&
        this.title == other.title &&
        this.icon == other.icon &&
        this.dot == other.dot &&
        this.id == other.id;
  }

  @override
  int get hashCode => hashValues(date, title, icon, id);

  @override
  DateTime getDate() {
    return date;
  }

  @override
  int? getId() {
    return id;
  }

  @override
  Widget? getDot() {
    return dot;
  }

  @override
  Widget? getIcon() {
    return icon;
  }

  @override
  String? getTitle() {
    return title;
  }
}

abstract class EventInterface {
  DateTime getDate();
  String? getTitle();
  Widget? getIcon();
  Widget? getDot();
  int? getId();
}
