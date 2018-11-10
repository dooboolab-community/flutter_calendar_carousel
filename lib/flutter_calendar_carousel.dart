library flutter_calendar_dooboo;

/// A Calculator.
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';

class CalendarCarousel extends StatefulWidget {
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
  final Widget defaultMarkedDateWidget = Positioned(
    child: Container(
      color: Colors.blueAccent,
      height: 4.0,
      width: 4.0,
    ),
    bottom: 4.0,
    left: 18.0,
  );

  final List<String> weekDays;
  final double viewportFraction;
  final TextStyle prevDaysTextStyle;
  final TextStyle daysTextStyle;
  final TextStyle nextDaysTextStyle;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final double height;
  final double width;
  final TextStyle todayTextStyle;
  final Color dayButtonColor;
  final Color todayBorderColor;
  final Color todayButtonColor;
  final DateTime selectedDateTime;
  final TextStyle selectedDayTextStyle;
  final Color selectedDayButtonColor;
  final Color selectedDayBorderColor;
  final bool daysHaveCircularBorder;
  final Function(DateTime) onDayPressed;
  final TextStyle weekdayTextStyle;
  final Color iconColor;
  final TextStyle headerTextStyle;
  final Widget headerText;
  final TextStyle weekendTextStyle;
  final List<DateTime> markedDates;
  final Color markedDateColor;
  final Widget markedDateWidget;
  final EdgeInsets headerMargin;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;
  final bool weekFormat;

  CalendarCarousel(
      {this.weekDays = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'],
      this.viewportFraction = 1.0,
      this.prevDaysTextStyle,
      this.daysTextStyle,
      this.nextDaysTextStyle,
      this.prevMonthDayBorderColor = Colors.transparent,
      this.thisMonthDayBorderColor = Colors.transparent,
      this.nextMonthDayBorderColor = Colors.transparent,
      this.dayPadding = 2.0,
      this.height = double.infinity,
      this.width = double.infinity,
      this.todayTextStyle,
      this.dayButtonColor = Colors.transparent,
      this.todayBorderColor = Colors.red,
      this.todayButtonColor = Colors.red,
      this.selectedDateTime,
      this.selectedDayTextStyle,
      this.selectedDayBorderColor = Colors.green,
      this.selectedDayButtonColor = Colors.green,
      this.daysHaveCircularBorder,
      this.onDayPressed,
      this.weekdayTextStyle,
      this.iconColor = Colors.blueAccent,
      this.headerTextStyle,
      this.headerText,
      this.weekendTextStyle,
      this.markedDates,
      @deprecated this.markedDateColor,
      this.markedDateWidget,
      this.headerMargin = const EdgeInsets.symmetric(vertical: 16.0),
      this.childAspectRatio = 1.0,
      this.weekDayMargin = const EdgeInsets.only(bottom: 4.0),
      this.weekFormat = false});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarCarousel> {
  PageController _controller;
  List<DateTime> _dates = List(3);
  DateTime _selectedDate = DateTime.now();
  int _startWeekday = 0;
  int _endWeekday = 0;

  @override
  initState() {
    super.initState();
    initializeDateFormatting();

    /// setup pageController
    _controller = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.viewportFraction,

      /// width percentage
    );
    this._setDate();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: <Widget>[
          Container(
            margin: widget.headerMargin,
            child: DefaultTextStyle(
              style: widget.headerTextStyle != null
                  ? widget.headerTextStyle
                  : widget.defaultHeaderTextStyle,
              child: widget.weekFormat
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => resetToToday(),
                          icon: Icon(Icons.today, color: widget.iconColor),
                        ),
                        Container(
                          child: widget.headerText != null
                              ? widget.headerText
                              : Text(
                                  '${DateFormat.yMMM().format(this._dates[1])}',
                                ),
                        ),
                        IconButton(
                          onPressed: () => selectDateFromPicker(),
                          icon: Icon(
                            Icons.calendar_today,
                            color: widget.iconColor,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => _setDate(page: 0),
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: widget.iconColor,
                          ),
                        ),
                        Container(
                          child: widget.headerText != null
                              ? widget.headerText
                              : Text(
                                  '${DateFormat.yMMM().format(this._dates[1])}',
                                ),
                        ),
                        IconButton(
                          onPressed: () => _setDate(page: 2),
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            color: widget.iconColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Container(
            child: widget.weekDays == null
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: this._renderWeekDays(),
                  ),
          ),
          Expanded(
            child: widget.weekFormat
                ? Builder(builder: weekBuilder, key: widget.key)
                : PageView.builder(
                    itemCount: 3,
                    onPageChanged: (value) {
                      this._setDate(page: value);
                    },
                    controller: _controller,
                    itemBuilder: (context, index) {
                      return builder(index);
                    },
                    pageSnapping: true,
                  ),
          ),
        ],
      ),
    );
  }

  builder(int slideIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    int totalItemCount = DateTime(
          this._dates[slideIndex].year,
          this._dates[slideIndex].month + 1,
          0,
        ).day +
        this._startWeekday +
        (7 - this._endWeekday);
    int year = this._dates[slideIndex].year;
    int month = this._dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,
            child: child,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: GridView.count(
                crossAxisCount: 7,
                childAspectRatio: widget.childAspectRatio,
                padding: EdgeInsets.zero,
                children: List.generate(totalItemCount,

                    /// last day of month + weekday
                    (index) {
                  bool isToday =
                      DateTime.now().day == index + 1 - this._startWeekday &&
                          DateTime.now().month == month &&
                          DateTime.now().year == year;
                  bool isSelectedDay = widget.selectedDateTime != null &&
                      widget.selectedDateTime.year == year &&
                      widget.selectedDateTime.month == month &&
                      widget.selectedDateTime.day ==
                          index + 1 - this._startWeekday;
                  bool isPrevMonthDay = index < this._startWeekday;
                  bool isNextMonthDay = index >=
                      (DateTime(year, month + 1, 0).day) + this._startWeekday;
                  bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                  DateTime now = DateTime(year, month, 1);
                  TextStyle textStyle;
                  TextStyle defaultTextStyle;
                  if (isPrevMonthDay) {
                    now = now
                        .subtract(Duration(days: this._startWeekday - index));
                    textStyle = widget.prevDaysTextStyle;
                    defaultTextStyle = widget.defaultPrevDaysTextStyle;
                  } else if (isThisMonthDay) {
                    now = DateTime(year, month, index + 1 - this._startWeekday);
                    textStyle = isSelectedDay
                        ? widget.selectedDayTextStyle
                        : isToday
                            ? widget.todayTextStyle
                            : widget.daysTextStyle;
                    defaultTextStyle = isSelectedDay
                        ? widget.defaultSelectedDayTextStyle
                        : isToday
                            ? widget.defaultTodayTextStyle
                            : widget.defaultDaysTextStyle;
                  } else {
                    now = DateTime(year, month, index + 1 - this._startWeekday);
                    textStyle = widget.nextDaysTextStyle;
                    defaultTextStyle = widget.defaultNextDaysTextStyle;
                  }
                  return Container(
                    margin: EdgeInsets.all(widget.dayPadding),
                    child: FlatButton(
                      color: isSelectedDay && widget.todayBorderColor != null
                          ? widget.selectedDayBorderColor
                          : isToday && widget.todayBorderColor != null
                              ? widget.todayButtonColor
                              : widget.dayButtonColor,
                      onPressed: () => widget.onDayPressed(DateTime(
                          year, month, index + 1 - this._startWeekday)),
                      padding: EdgeInsets.all(widget.dayPadding),
                      shape: widget.daysHaveCircularBorder == null
                          ? CircleBorder()
                          : widget.daysHaveCircularBorder
                              ? CircleBorder(
                                  side: BorderSide(
                                    color: isPrevMonthDay
                                        ? widget.prevMonthDayBorderColor
                                        : isNextMonthDay
                                            ? widget.nextMonthDayBorderColor
                                            : isToday &&
                                                    widget.todayBorderColor !=
                                                        null
                                                ? widget.todayBorderColor
                                                : widget
                                                    .thisMonthDayBorderColor,
                                  ),
                                )
                              : RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: isPrevMonthDay
                                        ? widget.prevMonthDayBorderColor
                                        : isNextMonthDay
                                            ? widget.nextMonthDayBorderColor
                                            : isToday &&
                                                    widget.todayBorderColor !=
                                                        null
                                                ? widget.todayBorderColor
                                                : widget
                                                    .thisMonthDayBorderColor,
                                  ),
                                ),
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: DefaultTextStyle(
                              style: (index % 7 == 0 || index % 7 == 6) &&
                                      !isSelectedDay &&
                                      !isToday
                                  ? widget.defaultWeekendTextStyle
                                  : isToday
                                      ? widget.defaultTodayTextStyle
                                      : defaultTextStyle,
                              child: Text(
                                '${now.day}',
                                style: (index % 7 == 0 || index % 7 == 6) &&
                                        !isSelectedDay &&
                                        !isToday
                                    ? widget.weekendTextStyle
                                    : isToday
                                        ? widget.todayTextStyle
                                        : textStyle,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          _renderMarked(now),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget weekBuilder(BuildContext context) {
    List<DateTime> weekDays = getDaysInWeek(selectedDate: this._selectedDate);

    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: GridView.count(
              crossAxisCount: 7,
              childAspectRatio: widget.childAspectRatio,
              padding: EdgeInsets.zero,
              children: List.generate(weekDays.length,

                  /// last day of month + weekday
                  (index) {
                bool isToday = weekDays[index].day == DateTime.now().day &&
                    weekDays[index].month == DateTime.now().month &&
                    weekDays[index].year == DateTime.now().year;
                bool isSelectedDay = this._selectedDate != null &&
                    this._selectedDate.year == weekDays[index].year &&
                    this._selectedDate.month == weekDays[index].month &&
                    this._selectedDate.day == weekDays[index].day;
                bool isPrevMonthDay =
                    weekDays[index].month < this._selectedDate.month;
                bool isNextMonthDay =
                    weekDays[index].month > this._selectedDate.month;
                bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                DateTime now = weekDays[index];
                TextStyle textStyle;
                TextStyle defaultTextStyle;
                if (isPrevMonthDay) {
                  textStyle = widget.prevDaysTextStyle;
                  defaultTextStyle = widget.defaultPrevDaysTextStyle;
                } else if (isThisMonthDay) {
                  textStyle = isSelectedDay
                      ? widget.selectedDayTextStyle
                      : isToday ? widget.todayTextStyle : widget.daysTextStyle;
                  defaultTextStyle = isSelectedDay
                      ? widget.defaultSelectedDayTextStyle
                      : isToday
                          ? widget.defaultTodayTextStyle
                          : widget.defaultDaysTextStyle;
                } else {
                  textStyle = widget.nextDaysTextStyle;
                  defaultTextStyle = widget.defaultNextDaysTextStyle;
                }

                return Container(
                  margin: EdgeInsets.all(widget.dayPadding),
                  child: FlatButton(
                    color: isSelectedDay && widget.todayBorderColor != null
                        ? widget.selectedDayBorderColor
                        : isToday && widget.todayBorderColor != null
                            ? widget.todayButtonColor
                            : widget.dayButtonColor,
                    onPressed: () => _onDayPressed(now),
                    padding: EdgeInsets.all(widget.dayPadding),
                    shape: widget.daysHaveCircularBorder == null
                        ? CircleBorder()
                        : widget.daysHaveCircularBorder
                            ? CircleBorder(
                                side: BorderSide(
                                  color: isPrevMonthDay
                                      ? widget.prevMonthDayBorderColor
                                      : isNextMonthDay
                                          ? widget.nextMonthDayBorderColor
                                          : isToday &&
                                                  widget.todayBorderColor !=
                                                      null
                                              ? widget.todayBorderColor
                                              : widget.thisMonthDayBorderColor,
                                ),
                              )
                            : RoundedRectangleBorder(
                                side: BorderSide(
                                  color: isPrevMonthDay
                                      ? widget.prevMonthDayBorderColor
                                      : isNextMonthDay
                                          ? widget.nextMonthDayBorderColor
                                          : isToday &&
                                                  widget.todayBorderColor !=
                                                      null
                                              ? widget.todayBorderColor
                                              : widget.thisMonthDayBorderColor,
                                ),
                              ),
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: DefaultTextStyle(
                            style: (index % 7 == 0 || index % 7 == 6) &&
                                    !isSelectedDay &&
                                    !isToday
                                ? widget.defaultWeekendTextStyle
                                : isToday
                                    ? widget.defaultTodayTextStyle
                                    : defaultTextStyle,
                            child: Text(
                              '${now.day}',
                              style: (index % 7 == 0 || index % 7 == 6) &&
                                      !isSelectedDay &&
                                      !isToday
                                  ? widget.weekendTextStyle
                                  : isToday ? widget.todayTextStyle : textStyle,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        _renderMarked(now),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  List<DateTime> getDaysInWeek({DateTime selectedDate}) {
    if (selectedDate == null) selectedDate = new DateTime.now();

    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selectedDate);

    return Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
        .toList();
  }

  void resetToToday() {
    _selectedDate = new DateTime.now();
    setState(() {
      this._selectedDate = _selectedDate;
    });
  }

  void _onDayPressed(DateTime picked) {
    if (picked == null) return;
    setState(() {
      this._selectedDate = picked;
    });
  }

  Future<Null> selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: this._selectedDate ?? new DateTime.now(),
      firstDate: new DateTime(1960),
      lastDate: new DateTime(2050),
    );

    if (selected != null) {
      setState(() {
        this._selectedDate = selected;
      });
      // updating selected date range based on selected week
    }
  }

  void _setDate({
    int page,
  }) {
    if (page == null) {
      /// setup dates
      DateTime date0 =
          DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
      DateTime date1 = DateTime(DateTime.now().year, DateTime.now().month, 1);
      DateTime date2 =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 1);

      this.setState(() {
        /// setup current day
        _startWeekday = date1.weekday;
        _endWeekday = date2.weekday;
        this._dates = [
          date0,
          date1,
          date2,
        ];
        this._selectedDate =
            widget.selectedDateTime ? widget.selectedDateTime : DateTime.now();
      });
    } else if (page == 1) {
      return;
    } else {
      print('page: $page');
      List<DateTime> dates = this._dates;
      print('dateLength: ${dates.length}');
      if (page == 0) {
        dates[2] = DateTime(dates[0].year, dates[0].month + 1, 1);
        dates[1] = DateTime(dates[0].year, dates[0].month, 1);
        dates[0] = DateTime(dates[0].year, dates[0].month - 1, 1);
        page = page + 1;
      } else if (page == 2) {
        dates[0] = DateTime(dates[2].year, dates[2].month - 1, 1);
        dates[1] = DateTime(dates[2].year, dates[2].month, 1);
        dates[2] = DateTime(dates[2].year, dates[2].month + 1, 1);
        page = page - 1;
      }

      this.setState(() {
        _startWeekday = dates[page].weekday;
        _endWeekday = dates[page + 1].weekday;
        this._dates = dates;
      });

      print('dates');
      print(this._dates);

      _controller.animateToPage(page,
          duration: Duration(milliseconds: 1), curve: Threshold(0.0));
    }

    print('startWeekDay: $_startWeekday');
    print('endWeekDay: $_endWeekday');
  }

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];
    for (var weekDay in widget.weekDays) {
      list.add(
        Expanded(
            child: Container(
          margin: widget.weekDayMargin,
          child: Center(
            child: DefaultTextStyle(
              style: widget.defaultWeekdayTextStyle,
              child: Text(
                weekDay,
                style: widget.weekdayTextStyle,
              ),
            ),
          ),
        )),
      );
    }
    return list;
  }

  Widget _renderMarked(DateTime now) {
    if (widget.markedDates != null && widget.markedDates.length > 0) {
      List<DateTime> markedDates = widget.markedDates.map((date) {
        return DateTime(date.year, date.month, date.day);
      }).toList();
      if (markedDates.contains(now)) {
        return widget.markedDateWidget != null
            ? widget.markedDateWidget
            : widget.defaultMarkedDateWidget;
      }
    }
    return Container();
  }
}
