library flutter_calendar_dooboo;

/// A Calculator.
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';

class CalendarCarousel extends StatefulWidget {
  final DateTime current;
  final double height;
  final double viewportFraction;

  CalendarCarousel({
    @required this.current,
    this.height = 400.0,
    this.viewportFraction = 1.0,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarCarousel> {
  PageController _controller;
  List<DateTime> _dates = List(3);
  int _startWeekday = 0;
  int _endWeekday = 0;

  @override
  initState() {
    super.initState();
    /// setup pageController
    _controller = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: widget.viewportFraction, /// width percentage
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
      height: widget.height,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              '${DateFormat.yMMM().format(this._dates[1])}',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blue,
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
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
    ).day + this._startWeekday + (7 - this._endWeekday);
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
      child: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: GridView.count(
                  crossAxisCount: 7,
                  childAspectRatio: 0.8,
                  children: List.generate(
                    totalItemCount, /// last day of month + weekday
                        (index) {
                      DateTime now = DateTime(year, month, 1);
                      if (index <= this._startWeekday) {
                        now = now.subtract(Duration(days: this._startWeekday - index));
                      } else if (index > (DateTime(year, month + 1, 0).day) + this._startWeekday) {
                        now = DateTime(year, month, index + 1 - this._startWeekday);
                      } else {
                        now = DateTime(year, month, index + 1 - this._startWeekday);
                      }
                      return Center(
                        child: Text(
                          '${now.day}',
                          style: Theme.of(context).textTheme.headline,
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setDate({
    int page,
  }) {
    if (page == null) {
      /// setup dates
      DateTime date0 = DateTime(widget.current.year, widget.current.month - 1 , 1);
      DateTime date1 = DateTime(widget.current.year, widget.current.month , 1);
      DateTime date2 = DateTime(widget.current.year, widget.current.month + 1 , 1);

      this.setState(() {
        /// setup current day
        _startWeekday = date1.weekday;
        _endWeekday = date2.weekday;
        this._dates = [
          date0, date1, date2,
        ];
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

      _controller.animateToPage(page, duration: Duration(milliseconds: 1), curve: Threshold(0.0));
    }

    print('startWeekDay: $_startWeekday');
    print('endWeekDay: $_endWeekday');
  }
}