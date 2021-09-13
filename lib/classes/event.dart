import 'package:flutter/material.dart';

class Event implements EventInterface {
  final DateTime date;
  final String? title;
  final String? description;
  final String? location;
  final Widget? icon;
  final Widget? dot;
  final int? id;
  Event({
    this.id,
    required this.date,
    this.title,
    this.description,
    this.location,
    this.icon,
    this.dot,
  });

  @override
  bool operator ==(dynamic other) {
    return this.date == other.date &&
        this.title == other.title &&
        this.description == other.description &&
        this.location == other.location &&
        this.icon == other.icon &&
        this.dot == other.dot &&
        this.id == other.id;
  }

  @override
  int get hashCode => hashValues(date, description, location, title, icon, id);

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

  @override
  String? getDescription() {
    return description;
  }

  @override
  String? getLocation() {
    return location;
  }
}

abstract class EventInterface {
  DateTime getDate();
  String? getTitle();
  String? getDescription();
  String? getLocation();
  Widget? getIcon();
  Widget? getDot();
  int? getId();
}
