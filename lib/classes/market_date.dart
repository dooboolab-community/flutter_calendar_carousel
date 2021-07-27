import 'package:flutter/material.dart';

class MarkedDate implements MarkedDateInterface {
  final Color color;
  final Color? borderColor;
  final int? id;
  final TextStyle? textStyle;
  final dateTime date;

  MarkedDate({
    required this.color,
    this.id,
    this.borderColor,
    this.textStyle,
    required this.date,
  });

  @override
  bool operator ==(dynamic other) {
    return this.date == other.date &&
        this.color == other.color &&
        this.textStyle == other.textStyle &&
        this.borderColor == other.BorderColor &&
        this.id == other.id;
  }

  @override
  DateTime getDate() => this.date;

  @override
  int getId() => this.id;

  @override
  int getColor() => this.color;

  @override
  Color? getBorderColor() => this.borderColor;

  @override
  TextStyle? getTextStyle() => this.textStyle;
}




abstract class MarkedDateInterface {
  DateTime getDate();
  Color? getColor();
  Color? getBorderColor();
  int? getId();
  TextStyle getTextStyle();

}
