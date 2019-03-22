import 'dart:ui';

import 'package:flutter/material.dart';

import 'pages/splash_page.dart';

void main() => runApp(_widgetForRoute(window.defaultRouteName));

Widget _widgetForRoute(String route) {
  switch (route) {
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
