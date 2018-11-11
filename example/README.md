# flutter_calendar_carousel
```dart
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
Widget widget() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    child: CalendarCarousel(
      current: DateTime.now(),
      onDayPressed: (DateTime date) {
        this.setState(() => _currentDate = date);
      },
      thisMonthDayBorderColor: Colors.grey,
      height: 420.0,
      selectedDateTime: _currentDate,
      daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
      markedDatesMap: _markedDateMap,
//          weekendStyle: TextStyle(
//            color: Colors.red,
//          ),
//          weekDays: null, /// for pass null when you do not want to render weekDays
//          headerText: Container( /// Example for rendering custom header
//            child: Text('Custom Header'),
//          ),
    ),
  );
}
```