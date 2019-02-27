import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show WeekdayFormat;
import 'package:intl/intl.dart' show DateFormat;

import 'package:flutter_calendar_carousel/src/weekday_row.dart';
import 'package:flutter/material.dart';

void main() {
  final format = DateFormat.yMMM("en_US");
  final margin = const EdgeInsets.only(bottom: 4.0);

  testWidgets('test short weekday row', (WidgetTester tester) async {
    await tester.pumpWidget(
        wrapped(
          WeekdayRow(true,
              WeekdayFormat.short,
              margin, null, format),
        )
    );

    expect(find.text('Sun'), findsOneWidget);
    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Tue'), findsOneWidget);
    expect(find.text('Wed'), findsOneWidget);
    expect(find.text('Thu'), findsOneWidget);
    expect(find.text('Fri'), findsOneWidget);
    expect(find.text('Sat'), findsOneWidget);
  });
}

Widget wrapped(Widget widget) => Directionality(
  textDirection: TextDirection.ltr,
  child: widget,
);