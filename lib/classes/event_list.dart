import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class EventList {
  Map<DateTime, List<Event>> events;

  EventList({
    this.events,
  });


  void add(DateTime date, Event event){
    if(events != null && events.containsKey(date)) {
      events[date].add(event);
    }
    else {
      events = { date: [event] };
    }
  }

  void addAll(DateTime date, List<Event> events){
    if(this.events != null && this.events.containsKey(date)) {
      this.events[date].addAll(events);
    }
    else {
      this.events = { date: events };
    }
  }

  bool remove(DateTime date, Event event){
    return events != null && events.containsKey(date)
      ? events[date].remove(event)
      : true;
  }

  List<Event> removeAll(DateTime date) {
    return events != null && events.containsKey(date)
      ? events.remove(date)
      : true;
  }

  void clear(){
    if(events != null) {
      events.clear();
    }
    else{
      events = {};
    }
  }

  List<Event> getEvents(DateTime date){
    return events != null && events.containsKey(date)
      ? events[date]
      : [];
  }
}