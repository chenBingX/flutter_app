import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        color: Colors.lightBlue,
        child: Text(
          'Hello, Flutter!',
          style: TextStyle(decoration: TextDecoration.none),
        ),
      ),
    );
  }
}
