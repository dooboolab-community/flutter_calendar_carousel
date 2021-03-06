// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../lib/classes/event.dart';

void main() {
  testWidgets('Default test for Calendar Carousel',
      (WidgetTester tester) async {
    DateTime? pressedDay;
    //  Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Container(
          child: CalendarCarousel(
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
            markedDateIconBuilder: (Event event) {
              return event.icon ?? Icon(Icons.help_outline);
            },
            todayButtonColor: Colors.transparent,
            todayBorderColor: Colors.green,
            markedDateMoreShowTotal:
                true, // null for not showing hidden events indicator
            onDayPressed: (date, event) {
              pressedDay = date;
            },
          ),
        ),
      ),
    ));

    expect(find.byType(CalendarCarousel), findsOneWidget);
    expect(pressedDay, isNull);
  });

  testWidgets(
    'make sure onDayPressed is called when the user tap',
    (WidgetTester tester) async {
      DateTime? pressedDay;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: CalendarCarousel(
                weekFormat: true,
                height: 200.0,
                onDayPressed: (date, event) {
                  pressedDay = date;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CalendarCarousel), findsOneWidget);

      expect(pressedDay, isNull);

      await tester.tap(find.text(DateTime.now().day.toString()));

      await tester.pump();

      expect(pressedDay, isNotNull);
    },
  );

  testWidgets(
    'should do nothing when the user tap and onDayPressed is not provided',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: CalendarCarousel(
                weekFormat: true,
                height: 200.0,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CalendarCarousel), findsOneWidget);

      await tester.tap(find.text(DateTime.now().day.toString()));
      await tester.pump();
    },
  );

  testWidgets(
    'make sure onDayLongPressed is called when the user press and hold',
    (WidgetTester tester) async {
      DateTime? longPressedDay;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: CalendarCarousel(
                weekFormat: true,
                height: 200.0,
                onDayLongPressed: (date) {
                  longPressedDay = date;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CalendarCarousel), findsOneWidget);

      expect(longPressedDay, isNull);

      await tester.longPress(find.text(DateTime.now().day.toString()));
      await tester.pump();

      expect(longPressedDay, isNotNull);
    },
  );

  testWidgets(
    'should do nothing when the user press and hold and onDayLongPressed is not provided',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              child: CalendarCarousel(
                weekFormat: true,
                height: 200.0,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CalendarCarousel), findsOneWidget);

      await tester.longPress(find.text(DateTime.now().day.toString()));
      await tester.pump();
    },
  );
}
