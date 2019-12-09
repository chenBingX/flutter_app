import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/pages/flight_tracker_page.dart';

import 'pages/splash_page.dart';

void main() => runApp(_widgetForRoute(window.defaultRouteName));

Widget _widgetForRoute(String route) {
  switch (route) {
    case 'flight_tracker':
      return Material(
        child: FlightTrackerPage(),
      );
    case 'route0':
      return MaterialApp(
        title: 'Flutter',
        home: SplashPage(),
      );
    case 'route1':
    case 'route2':
    case 'route3':
    default:
      return MaterialApp(
        title: 'Flutter',
        home: SplashPage(),
      );
  }
}
