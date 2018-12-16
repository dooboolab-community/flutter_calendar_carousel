import 'package:flutter/material.dart';

class Event {
  final DateTime date;
  final String title;
  final Widget icon;

  Event({
    this.date,
    this.title,
    this.icon
  }) : assert(date != null);
}