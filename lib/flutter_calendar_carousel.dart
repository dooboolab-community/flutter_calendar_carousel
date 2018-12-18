library flutter_calendar_dooboo;

import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

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
  final Function(DateTime, List<Event>) onDayPressed;
  final TextStyle weekdayTextStyle;
  final Color iconColor;
  final TextStyle headerTextStyle;
  final Widget headerText;
  final TextStyle weekendTextStyle;
  final List<DateTime> markedDates;
  final EventList markedDatesMap;
  final Color markedDateColor;
  final Widget markedDateWidget;
  final bool markedDateShowIcon;
  final Color markedDateIconBorderColor;
  final int markedDateIconMaxShown;
  final double markedDateIconMargin;
  final double markedDateIconOffset;
  final bool markedDateMoreShowTotal; // null - no indicator, true - show the total events, false - show the total of hidden events
  final Decoration markedDateMoreCustomDecoration;
  final TextStyle markedDateMoreCustomTextStyle;
  final EdgeInsets headerMargin;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;
  final bool weekFormat;
  final bool showWeekDays;
  final bool showHeader;
  final bool showHeaderButton;
  final ScrollPhysics customGridViewPhysics;
  final Function(DateTime) onCalendarChanged;
  final String locale;
  final DateTime minSelectedDate;
  final DateTime maxSelectedDate;
  final TextStyle inactiveDaysTextStyle;
  final TextStyle inactiveWeekendTextStyle;

  CalendarCarousel({
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
    @deprecated this.markedDates,
    this.markedDatesMap,
    @deprecated this.markedDateColor,
    this.markedDateShowIcon = false,
    this.markedDateIconBorderColor,
    this.markedDateIconMaxShown = 2,
    this.markedDateIconMargin = 5,
    this.markedDateIconOffset = 5,
    this.markedDateMoreShowTotal,
    this.markedDateMoreCustomDecoration,
    this.markedDateMoreCustomTextStyle,
    this.markedDateWidget,
    this.headerMargin = const EdgeInsets.symmetric(vertical: 16.0),
    this.childAspectRatio = 1.0,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4.0),
    this.showWeekDays = true,
    this.weekFormat = false,
    this.showHeader = true,
    this.showHeaderButton = true,
    this.customGridViewPhysics,
    this.onCalendarChanged,
    this.locale = "en",
    this.minSelectedDate,
    this.maxSelectedDate,
    this.inactiveDaysTextStyle,
    this.inactiveWeekendTextStyle,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarCarousel> {
  PageController _controller;
  List<DateTime> _dates = List(3);
  List<List<DateTime>> _weeks = List(3);
  DateTime _selectedDate = DateTime.now();
  int _startWeekday = 0;
  int _endWeekday = 0;
  DateFormat _localeDate;
  /// When FIRSTDAYOFWEEK is 0 in dart-intl, it represents Monday. However it is the second day in the arrays of Weekdays.
  /// Therefore we need to add 1 modulo 7 to pick the right weekday from intl. (cf. [GlobalMaterialLocalizations]) 
  int firstDayOfWeek = 0;
  /// If the setState called from this class, don't reload the selectedDate, but it should reload selected date if called from external class
  bool _isReloadSelectedDate = true;

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

    _localeDate = DateFormat.yMMM(widget.locale);
    firstDayOfWeek = (_localeDate.dateSymbols.FIRSTDAYOFWEEK + 1) % 7;
    if(widget.selectedDateTime != null) _selectedDate = widget.selectedDateTime;
    _setDate();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_isReloadSelectedDate) {
      if(widget.selectedDateTime != null) _selectedDate = widget.selectedDateTime;
      _setDatesAndWeeks();
    }
    else{
      _isReloadSelectedDate = true;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: <Widget>[
          widget.showHeader
          ? Container(
            margin: widget.headerMargin,
            child: DefaultTextStyle(
                style: widget.headerTextStyle != null
                    ? widget.headerTextStyle
                    : widget.defaultHeaderTextStyle,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      widget.showHeaderButton
                       ? IconButton(
                        onPressed: () => _setDate(0),
                        icon: Icon(Icons.chevron_left, color: widget.iconColor),
                      ) : Container(),
                      FlatButton(
                        onPressed: () => _selectDateFromPicker(),
                        child: widget.headerText != null
                            ? widget.headerText
                            : Text(
                                widget.weekFormat
                                    ? '${_localeDate.format(_weeks[1].first)}'
                                    : '${_localeDate.format(this._dates[1])}',
                                style: widget.headerTextStyle,
                              ),
                      ),
                      widget.showHeaderButton
                      ? IconButton(
                        onPressed: () => _setDate(2),
                        icon:
                            Icon(Icons.chevron_right, color: widget.iconColor),
                      ) : Container(),
                    ])),
          ) : Container(),
          Container(
            child: !widget.showWeekDays
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _renderWeekDays(),
            ),
          ),
          Expanded(
              child: PageView.builder(
            itemCount: 3,
            onPageChanged: (index) {
              this._setDate(index);
            },
            controller: _controller,
            itemBuilder: (context, index) {
              return widget.weekFormat ? weekBuilder(index) : builder(index);
            },
            pageSnapping: true,
          )),
        ],
      ),
    );
  }

  AnimatedBuilder builder(int slideIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    int totalItemCount = DateTime(
          _dates[slideIndex].year,
          _dates[slideIndex].month + 1,
          0,
        ).day +
        _startWeekday +
        (7 - _endWeekday);
    int year = _dates[slideIndex].year;
    int month = _dates[slideIndex].month;

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
                physics: widget.customGridViewPhysics,
                crossAxisCount: 7,
                childAspectRatio: widget.childAspectRatio,
                padding: EdgeInsets.zero,
                children: List.generate(totalItemCount,

                    /// last day of month + weekday
                    (index) {
                  bool isToday =
                      DateTime.now().day == index + 1 - _startWeekday &&
                          DateTime.now().month == month &&
                          DateTime.now().year == year;
                  bool isSelectedDay = widget.selectedDateTime != null &&
                      widget.selectedDateTime.year == year &&
                      widget.selectedDateTime.month == month &&
                      widget.selectedDateTime.day == index + 1 - _startWeekday;
                  bool isPrevMonthDay = index < _startWeekday;
                  bool isNextMonthDay = index >=
                      (DateTime(year, month + 1, 0).day) + _startWeekday;
                  bool isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                  DateTime now = DateTime(year, month, 1);
                  TextStyle textStyle;
                  TextStyle defaultTextStyle;
                  if (isPrevMonthDay) {
                    now = now.subtract(Duration(days: _startWeekday - index));
                    textStyle = widget.prevDaysTextStyle;
                    defaultTextStyle = widget.defaultPrevDaysTextStyle;
                  } else if (isThisMonthDay) {
                    now = DateTime(year, month, index + 1 - _startWeekday);
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
                    now = DateTime(year, month, index + 1 - _startWeekday);
                    textStyle = widget.nextDaysTextStyle;
                    defaultTextStyle = widget.defaultNextDaysTextStyle;
                  }
                  bool isSelectable = true;
                  if(widget.minSelectedDate != null
                      && now.millisecondsSinceEpoch < widget.minSelectedDate.millisecondsSinceEpoch ) isSelectable = false;
                  else if(widget.maxSelectedDate != null
                      && now.millisecondsSinceEpoch > widget.maxSelectedDate.millisecondsSinceEpoch ) isSelectable = false;
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
                              style: (_localeDate.dateSymbols.WEEKENDRANGE.contains((index - 1 + firstDayOfWeek) % 7)) &&
                                      !isSelectedDay &&
                                      !isToday
                                  ? (isSelectable ? widget.defaultWeekendTextStyle : widget.defaultInactiveWeekendTextStyle)
                                  : isToday
                                      ? widget.defaultTodayTextStyle
                                      : isSelectable
                                          ? defaultTextStyle
                                          : widget.defaultInactiveDaysTextStyle,
                              child: Text(
                                '${now.day}',
                                style: (_localeDate.dateSymbols.WEEKENDRANGE.contains((index - 1 + firstDayOfWeek) % 7)) &&
                                        !isSelectedDay &&
                                        !isToday
                                    ? (isSelectable ? widget.weekendTextStyle : widget.inactiveWeekendTextStyle)
                                    : isToday
                                        ? widget.todayTextStyle
                                        : isSelectable
                                            ? textStyle
                                            : widget.inactiveDaysTextStyle,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          widget.markedDatesMap != null
                              ? _renderMarkedMapContainer(now)
                              : _renderMarked(now),
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

  AnimatedBuilder weekBuilder(int slideIndex) {
    double screenWidth = MediaQuery.of(context).size.width;
    List<DateTime> weekDays = _weeks[slideIndex];

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
                          : isToday
                              ? widget.todayTextStyle
                              : widget.daysTextStyle;
                      defaultTextStyle = isSelectedDay
                          ? widget.defaultSelectedDayTextStyle
                          : isToday
                              ? widget.defaultTodayTextStyle
                              : widget.defaultDaysTextStyle;
                    } else {
                      textStyle = widget.nextDaysTextStyle;
                      defaultTextStyle = widget.defaultNextDaysTextStyle;
                    }
                    bool isSelectable = true;
                    if(widget.minSelectedDate != null
                        && now.millisecondsSinceEpoch < widget.minSelectedDate.millisecondsSinceEpoch ) isSelectable = false;
                    else if(widget.maxSelectedDate != null
                        && now.millisecondsSinceEpoch > widget.maxSelectedDate.millisecondsSinceEpoch ) isSelectable = false;
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
                                    ? (isSelectable ? widget.defaultWeekendTextStyle : widget.defaultInactiveWeekendTextStyle)
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
                                          : isSelectable
                                              ? textStyle
                                              : widget.inactiveDaysTextStyle,
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
        ));
  }

  List<DateTime> _getDaysInWeek([DateTime selectedDate]) {
    if (selectedDate == null) selectedDate = new DateTime.now();

    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selectedDate);

    return Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
        .toList();
  }

  void _onDayPressed(DateTime picked) {
    if (picked == null) return;
    if(widget.minSelectedDate != null &&
      picked.millisecondsSinceEpoch < widget.minSelectedDate.millisecondsSinceEpoch) return;
    if(widget.maxSelectedDate != null &&
      picked.millisecondsSinceEpoch > widget.maxSelectedDate.millisecondsSinceEpoch) return;

    setState(() {
      _isReloadSelectedDate = false;
      _selectedDate = picked;
    });
    if(widget.onDayPressed != null)
      widget.onDayPressed(
          picked,
          widget.markedDatesMap != null
            ? widget.markedDatesMap.getEvents(picked)
            : []
      );
    _setDate();
  }

  Future<Null> _selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? new DateTime.now(),
      firstDate: widget.minSelectedDate != null ? widget.minSelectedDate : DateTime(1960),
      lastDate: widget.maxSelectedDate != null ? widget.maxSelectedDate : DateTime(2050),
    );

    if (selected != null) {
      // updating selected date range based on selected week
      setState(() {
        _isReloadSelectedDate = false;
        _selectedDate = selected;
      });
      if(widget.onDayPressed != null)
        widget.onDayPressed(
          selected,
          widget.markedDatesMap != null
            ? widget.markedDatesMap.getEvents(selected)
            : []
        );
      _setDate();
    }
  }

  void _setDatesAndWeeks() {
    /// Setup default calendar format
    DateTime date0 =
    DateTime(this._selectedDate.year, this._selectedDate.month - 1, 1);
    DateTime date1 = DateTime(this._selectedDate.year, this._selectedDate.month, 1);
    DateTime date2 =
    DateTime(this._selectedDate.year, this._selectedDate.month + 1, 1);

    /// Setup week-only format
    DateTime now = this._selectedDate;
    List<DateTime> week0 =
    _getDaysInWeek(now.subtract(new Duration(days: 7)));
    List<DateTime> week1 = _getDaysInWeek(now);
    List<DateTime> week2 = _getDaysInWeek(now.add(new Duration(days: 7)));


    _startWeekday = date1.weekday - firstDayOfWeek;
    _endWeekday = date2.weekday - firstDayOfWeek;
    this._dates = [
      date0,
      date1,
      date2,
    ];
    this._weeks = [
      week0,
      week1,
      week2,
    ];
//        this._selectedDate = widget.selectedDateTime != null
//            ? widget.selectedDateTime
//            : DateTime.now();
  }

  void _setDate([int page = -1]) {
    if (page == -1) {
      setState(() {
        _isReloadSelectedDate = false;
        _setDatesAndWeeks();
      });
    } else if (page == 1) {
      return;
    } else {
      if (widget.weekFormat) {
        DateTime curr;
        List<List<DateTime>> newWeeks = this._weeks;
        if (page == 0) {
          curr = _weeks[0].first;
          newWeeks[0] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day - 7));
          newWeeks[1] = _getDaysInWeek(curr);
          newWeeks[2] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day + 7));
          page += 1;
        } else if (page == 2) {
          curr = _weeks[2].first;
          newWeeks[1] = _getDaysInWeek(curr);
          newWeeks[0] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day - 7));
          newWeeks[2] =
              _getDaysInWeek(DateTime(curr.year, curr.month, curr.day + 7));
          page -= 1;
        }
        setState(() {
          _isReloadSelectedDate = false;
          this._weeks = newWeeks;
        });

        print('weeks');
        print(this._weeks);

        _controller.animateToPage(page,
            duration: Duration(milliseconds: 1), curve: Threshold(0.0));
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

        setState(() {
          _isReloadSelectedDate = false;
          _startWeekday = dates[page].weekday - firstDayOfWeek;
          _endWeekday = dates[page + 1].weekday - firstDayOfWeek;
          this._dates = dates;
        });

        print('dates');
        print(this._dates);

        _controller.animateToPage(page,
            duration: Duration(milliseconds: 1), curve: Threshold(0.0));
      }
    }

    print('startWeekDay: $_startWeekday');
    print('endWeekDay: $_endWeekday');

    //call callback
    if(this._dates.length == 3 && widget.onCalendarChanged != null){
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
            _isReloadSelectedDate = false;
            widget.onCalendarChanged(this._dates[1]);
      });
    }
  }

  List<Widget> _renderWeekDays() {
    List<Widget> list = [];
    /// because of number of days in a week is 7, so it would be easier to count it til 7.
    for (var i = firstDayOfWeek, count = 0; count < 7; i = (i + 1) % 7, count++) {
      String weekDay = _localeDate.dateSymbols.SHORTWEEKDAYS[i];
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

  Widget _renderMarkedMapContainer(DateTime now) {
    if(widget.markedDateShowIcon) {
      return Stack(
        children: _renderMarkedMap(now),
      );
    }
    else {
      return Container(
        height: double.infinity,
        padding: EdgeInsets.only(bottom: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _renderMarkedMap(now),
        ),
      );
    }
  }

  List<Widget> _renderMarkedMap(DateTime now) {
    if (widget.markedDatesMap != null && widget.markedDatesMap.getEvents(now).length > 0) {
      List<Widget> tmp = [];
      int count = 0;
      double offset = 0;
      double padding = widget.markedDateIconMargin;
      widget.markedDatesMap.getEvents(now).forEach((event) {
        if(widget.markedDateShowIcon) {
          if(tmp.length > 0 && tmp.length < widget.markedDateIconMaxShown){
            offset += widget.markedDateIconOffset;
          }
          if(tmp.length < widget.markedDateIconMaxShown) {
            tmp.add(
              Center(
                child: new Container(
                  padding: EdgeInsets.only(
                    top: padding + offset,
                    left: padding + offset,
                    right: padding - offset,
                    bottom: padding - offset,
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: event.icon,
                )
              )
            );
          }
          else{
            count++;
          }
          if(count > 0 && widget.markedDateMoreShowTotal != null ){
            tmp.add(
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: widget.markedDateMoreCustomDecoration == null
                      ? new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(1000)),
                  )
                      : widget.markedDateMoreCustomDecoration
                  ,
                  child: Center(
                    child: Text(
                      widget.markedDateMoreShowTotal ? (count + widget.markedDateIconMaxShown).toString() : (count.toString() + '+'),
                      style: widget.markedDateMoreCustomTextStyle == null
                          ? TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.normal
                      )
                          : widget.markedDateMoreCustomTextStyle
                      ,
                    ),
                  ),
                ),
              )
            );
          }
        }
        else {
          if (widget.markedDateWidget != null) {
            tmp.add(widget.markedDateWidget);
          } else {
            tmp.add(widget.defaultMarkedDateWidget);
          }
        }
      });
      return tmp;
    }
    return [];
  }
}
