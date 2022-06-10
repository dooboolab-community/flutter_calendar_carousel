import 'package:flutter/material.dart';

class MarkedDate implements MarkedDateInterface {
  final Color color;
  final int? id;
  final TextStyle? textStyle;
  final DateTime date;

  MarkedDate({
    required this.color,
    this.id,
    this.textStyle,
    required this.date,
  });

  @override
  bool operator ==(dynamic other) {
    return this.date == other.date &&
        this.color == other.color &&
        this.textStyle == other.textStyle &&
        this.id == other.id;
  }

  @override
  DateTime getDate() => this.date;

  @override
  int? getId() => this.id;

  @override
  Color getColor() => this.color;

  @override
  TextStyle? getTextStyle() => this.textStyle;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}

abstract class MarkedDateInterface {
  DateTime getDate();
  Color getColor();
  int? getId();
  TextStyle? getTextStyle();
}
