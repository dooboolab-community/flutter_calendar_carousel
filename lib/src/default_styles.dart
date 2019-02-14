import 'package:flutter/material.dart';

final TextStyle defaultHeaderTextStyle = TextStyle(
	fontSize: 20.0,
	color: Colors.blue,
);
final TextStyle defaultPrevDaysTextStyle = TextStyle(
	color: Colors.grey,
	fontSize: 14.0,
);
final TextStyle defaultNextDaysTextStyle = TextStyle(
	color: Colors.grey,
	fontSize: 14.0,
);
final TextStyle defaultDaysTextStyle = TextStyle(
	color: Colors.black,
	fontSize: 14.0,
);
final TextStyle defaultTodayTextStyle = TextStyle(
	color: Colors.white,
	fontSize: 14.0,
);
final TextStyle defaultSelectedDayTextStyle = TextStyle(
	color: Colors.white,
	fontSize: 14.0,
);
final TextStyle defaultWeekdayTextStyle = TextStyle(
	color: Colors.deepOrange,
	fontSize: 14.0,
);
final TextStyle defaultWeekendTextStyle = TextStyle(
	color: Colors.pinkAccent,
	fontSize: 14.0,
);
final TextStyle defaultInactiveDaysTextStyle = TextStyle(
	color: Colors.black38,
	fontSize: 14.0,
);
final TextStyle defaultInactiveWeekendTextStyle = TextStyle(
	color: Colors.pinkAccent.withOpacity(0.6),
	fontSize: 14.0,
);
final Widget defaultMarkedDateWidget = Container(
	margin: EdgeInsets.symmetric(horizontal: 1.0),
	color: Colors.blueAccent,
	height: 4.0,
	width: 4.0,
);