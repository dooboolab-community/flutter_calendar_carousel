import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, WeekDay;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart' show DateFormat;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'dooboolab flutter calendar',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Calendar Carousel Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _currentDate = DateTime(2018, 12, 13);
  DateTime _currentDate2 = DateTime(2018, 12, 13);
  String _currentMonth = '';
//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(1000)),
      border: Border.all(
        color: Colors.blue,
        width: 2.0
      )
    ),
    child: new Icon(Icons.person, color:Colors.amber,),
  );

  List<Event> _markedDateMap = [
    new Event(
      date: new DateTime(2018, 12, 10),
      title: 'Event 1',
      icon: _eventIcon,
    ),
    new Event(
      date: new DateTime(2018, 12, 10),
      title: 'Event 2',
      icon: _eventIcon,
    ),
    new Event(
      date: new DateTime(2018, 12, 10),
      title: 'Event 3',
      icon: _eventIcon,
    ),
    new Event(
      date: new DateTime(2018, 12, 10),
      title: 'Event 4',
      icon: _eventIcon,
    ),
    new Event(
        date: new DateTime(2018, 12, 25),
        title: 'Event 5',
        icon: _eventIcon,
    ),
  ];

  CalendarCarousel _calendarCarousel;

  @override
  Widget build(BuildContext context) {
    _calendarCarousel = CalendarCarousel(
      onDayPressed: (DateTime date) {
        this.setState(() => _currentDate2 = date);
      },
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      weekends: [WeekDay.Sunday, WeekDay.Saturday],
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateMoreShowTotal: false, // null for not showing hidden events indicator
      showHeader: false,
      onCalendarChanged: (DateTime date){
        this.setState(() =>
        _currentMonth = DateFormat.yMMM().format(date));
      },
    );


    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //custom icon
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: CalendarCarousel(
                onDayPressed: (DateTime date) {
                  this.setState(() => _currentDate = date);
                },
                weekendTextStyle: TextStyle(
                  color: Colors.red,
                ),
                thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
//          headerText: Container( /// Example for rendering custom header
//            child: Text('Custom Header'),
//          ),
//          markedDates: _markedDate,
                weekFormat: false,
                weekends: [WeekDay.Sunday, WeekDay.Saturday],
                markedDatesMap: _markedDateMap,
                height: 420.0,
                selectedDateTime: _currentDate,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
                markedDateShowIcon: true,
                markedDateIconMaxShown: 2,
                markedDateMoreShowTotal: true, // null for not showing hidden events indicator
//          markedDateIconMargin: 9,
//          markedDateIconOffset: 3,
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.

            //custom icon without header
            Container(
              margin: EdgeInsets.only(
                top: 30.0,
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    )
                  ),
                  FlatButton(
                    child: Text('PREV'),
                    onPressed: (){
                      this.setState(() => _currentDate2 = DateTime(_currentDate2.year, _currentDate2.month - 1, 1));
                    },
                  ),
                  FlatButton(
                    child: Text('NEXT'),
                    onPressed: (){
                      this.setState(() => _currentDate2 = DateTime(_currentDate2.year, _currentDate2.month - 1, 1));
                    },
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: _calendarCarousel,
            ), //
          ],
        ),
      )
    );
  }
}
