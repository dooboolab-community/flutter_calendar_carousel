// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

void main() {
  DateTime selectedDateTime = DateTime.now();
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    //  Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Container(
          child: CalendarCarousel(
            selectedDateTime: selectedDateTime,
            daysHaveCircularBorder: null,
            weekendTextStyle: TextStyle(
              color: Colors.red,
            ),
            thisMonthDayBorderColor: Colors.grey,
            headerText: 'Custom Header',
            weekFormat: true,
            height: 200.0,
            showIconBehindDayText: true,
            customGridViewPhysics: NeverScrollableScrollPhysics(),
            markedDateShowIcon: true,
            markedDateIconMaxShown: 2,
            selectedDayTextStyle: TextStyle(
              color: Colors.yellow,
            ),
            todayTextStyle: TextStyle(
              color: Colors.blue,
            ),
            markedDateIconBuilder: (event) {
              return event.icon;
            },
            minSelectedDate: selectedDateTime.subtract(Duration(days: 360)),
            maxSelectedDate: selectedDateTime.add(Duration(days: 360)),
            todayButtonColor: Colors.transparent,
            todayBorderColor: Colors.green,
            markedDateMoreShowTotal:
                true, // null for not showing hidden events indicator
            onDayPressed: (date, event) {
              // this.setState(() => selectedDateTime = date);
              print('Test');
            },
          ),
        ),
      ),
    ));

    expect(find.byType(CalendarCarousel), findsOneWidget);
  });
}
