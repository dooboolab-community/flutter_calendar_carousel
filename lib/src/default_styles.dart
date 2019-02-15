import 'package:flutter/material.dart';

const TextStyle defaultHeaderTextStyle = const TextStyle(
	fontSize: 20.0,
	color: Colors.blue,
);
const TextStyle defaultPrevDaysTextStyle = const TextStyle(
	color: Colors.grey,
	fontSize: 14.0,
);
const TextStyle defaultNextDaysTextStyle = const TextStyle(
	color: Colors.grey,
	fontSize: 14.0,
);
const TextStyle defaultDaysTextStyle = const TextStyle(
	color: Colors.black,
	fontSize: 14.0,
);
const TextStyle defaultTodayTextStyle = const TextStyle(
	color: Colors.white,
	fontSize: 14.0,
);
const TextStyle defaultSelectedDayTextStyle = const TextStyle(
	color: Colors.white,
	fontSize: 14.0,
);
const TextStyle defaultWeekdayTextStyle = const TextStyle(
	color: Colors.deepOrange,
	fontSize: 14.0,
);
const TextStyle defaultWeekendTextStyle = const TextStyle(
	color: Colors.pinkAccent,
	fontSize: 14.0,
);
const TextStyle defaultInactiveDaysTextStyle = const TextStyle(
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