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
  int _currentWeekDay = 0;

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
                  children: List.generate(
                      DateTime(this._dates[slideIndex].year, this._dates[slideIndex].month + 1, 0).day + this._currentWeekDay, /// last day of month + weekday
                          (index) {
                        return Center(
                          child: Text(
                            this._currentWeekDay > index
                                ? ''
                                : '${index - this._currentWeekDay + 1}',
                            style: Theme.of(context).textTheme.headline,
                          ),
                        );
                      }),
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
        _currentWeekDay = date1.weekday;
        this._dates = [
          date0, date1, date2,
        ];
      });
    } else {
      List<DateTime> dates = this._dates;
      print('page: $page');
      print('dateLength: ${dates.length}');
      if (page == 0) {
        dates[1] = dates[0];
        dates[2] = dates[1];
        dates[0] = DateTime(this._dates[0].year, this._dates[0].month - 1, 1);
        page = page + 1;
      } else if (page == dates.length - 1) {
        dates[0] = dates[1];
        dates[1] = dates[2];
        dates[2] = DateTime(this._dates[dates.length - 1].year, this._dates[dates.length - 1].month + 1, 1);page = page - 1;
      }
      _controller.animateToPage(page, duration: Duration(milliseconds: 1), curve: Threshold(0.0));

      this.setState(() {
        _currentWeekDay = dates[page].weekday;
        this._dates = dates;
      });
    }
  }
}