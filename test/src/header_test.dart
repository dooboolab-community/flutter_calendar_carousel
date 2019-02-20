import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_calendar_carousel/src/calendar_header.dart';

void main() {

  testWidgets('Test Header', (WidgetTester tester) async {

    await tester.pumpWidget(CalendarHeader(
    ));

  });
}