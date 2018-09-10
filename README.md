# flutter_calendar_carousel
Calendar widget for flutter that is swipeable. This widget can help you build customizable calendar with scrollable actions.
<p align="left">
  <a href="https://pub.dartlang.org/packages/flutter_calendar_carousel"><img alt="pub version" src="https://img.shields.io/pub/v/flutter_calendar_carousel.svg?style=flat-square"></a>
</p>
<br/><img src="https://github.com/dooboolab/flutter_calendar_carousel/blob/master/docs/calendar1.gif"/>
<br/><img src="https://github.com/dooboolab/flutter_calendar_carousel/blob/master/docs/calendar2.gif"/>
<br/><img src="https://github.com/dooboolab/flutter_calendar_carousel/blob/master/docs/calendar3.gif"/>

## Getting Started
For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

## Props
| props | types | defaultValues |
| :------------ |:---------------: |:---------------:|
| weekDays | | ['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'] |
| viewPortFraction | `double` | 1.0 |
| prevDaysTextStyle | `TextStyle` | |
| daysTextStyle | `TextStyle` | |
| nextDaysTextStyle | `TextStyle` | |
| prevMonthDayBorderColor | `Color` | Colors.transparent |
| thisMonthDayBorderColor | `Color` | Colors.transparent |
| nextMonthDayBorderColor | `Color` | Colors.transparent |
| dayPadding | `double` | 2.0 |
| height | `double` | double.infinity |
| width | `double` | double.infinity |
| todayTextStyle | `TextStyle` | |
| dayButtonColor | `TextStyle` | Colors.red |
| todayBorderColor | `Color` | Colors.red |
| todayButtonColor | `Colors` | Colors.red |
| selectedDateTime | `DateTime` | |
| selectedDayTextStyle | `TextStyle` | |
| selectedDayBorderColor | `color` | Colors.green |
| selectedDayButtonColor | `color` | Colors.green |
| daysHaveCircularBorder | `bool` | |
| onDayPressed | `Func` | |
| weekdayTextStyle | `TextStyle` | |

## Install
Add ```flutter_calendar_carousel``` as a dependency in pubspec.yaml
For help on adding as a dependency, view the [documentation](https://flutter.io/using-packages/).

## Usage
```dart
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
    ),
  );
}
```

### TODO
- [x] Render weekdays.
- [ ] Customizable header.
- [ ] Customizable textStyles for days in weekend.
- [ ] Multiple days selections. 

## Help Maintenance
I've been maintaining quite many repos these days and burning out slowly. If you could help me cheer up, buying me a cup of coffee will make my life really happy and get much energy out of it.
<br/><a href="https://www.buymeacoffee.com/dooboolab" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>
