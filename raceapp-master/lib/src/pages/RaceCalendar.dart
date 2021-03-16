import 'package:app_races/src/widgets/RaceDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';

import '../models/Race.dart';

class RaceCalendar extends StatefulWidget {
  static final route = '/racesCalendar';
  RaceCalendar({Key key}) : super(key: key);
  String title;

  @override
  _RaceCalendarState createState() => _RaceCalendarState();
}

class _RaceCalendarState extends State<RaceCalendar> {
  Race race;
  bool scrolleable = true;
  DateTime _currentDate = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  CalendarCarousel _calendarCarousel, _calendarCarouselNoHeader;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      race = args;
      scrolleable = false;
    }

    DateTime _currentDate2 = race?.dateRace;
    DateTime _targetDateTime = race?.dateRace;
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.blue,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
      },
      selectedDayButtonColor: Colors.blue,
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      isScrollable: scrolleable,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.yellow, //Color fondo
        title: new Text(
          "Mi calendario",
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: RaceDrawer(),
      body: Stack(children: [
        buildBackgroundTopCircle(context),
        buildBackgroundBottomCircle(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: _calendarCarousel,
            ),
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
                  )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: _calendarCarouselNoHeader,
              height: 300,
            ),

            //
          ],
        ),
      ]),
    );
  }

  Positioned buildBackgroundTopCircle(BuildContext context) {
    return Positioned(
      top: 0,
      child: Transform.translate(
        offset: Offset(0.0, -MediaQuery.of(context).size.width / 1.3),
        child: Transform.scale(
          scale: 1.35,
          child: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.yellow[400],
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width,
                )),
          ),
        ),
      ),
    );
  }

  Positioned buildBackgroundBottomCircle(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height -
          MediaQuery.of(context).size.width,
      right: MediaQuery.of(context).size.width / 2,
      child: Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.yellow[200],
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width,
            )),
      ),
    );
  }
}
