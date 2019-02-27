import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show WeekdayFormat;
import 'package:intl/intl.dart';

import 'package:flutter_calendar_carousel/src/weekday_row.dart';
import 'package:flutter/material.dart';

void main() {
  final format = DateFormat.yMMM("en");
  final margin = const EdgeInsets.only(bottom: 4.0);

  testWidgets('test weekday row', (WidgetTester tester) async {
    await tester.pumpWidget(
        wrapped(
          WeekdayRow(true,
              WeekdayFormat.short,
              margin, null, format),
        ));
  });
}

Widget wrapped(Widget widget) => MaterialApp(
  home: Container(
    child: Material(child: widget),
  ),
);