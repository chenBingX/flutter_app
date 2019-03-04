import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/datas/page_data.dart';
import 'package:flutter_app/datas/user.dart';
import 'package:flutter_app/pages/anim_page.dart';
import 'package:flutter_app/pages/hero_page1.dart';

class HomePage extends StatelessWidget {
  final PageData data;

  // 带所需参数的构造函数
  const HomePage({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.grey,
              padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
              child: Text(
                data != null
                    ? "From pre page data：" + data.data
                    : 'There is no data!',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: RaisedButton(
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context, 'HomePage response!');
                },
                child: Text("Back with data"),
              ),
            ),
            // Anim Page
            Container(
              margin: EdgeInsets.only(top: 16),
              child: RaisedButton(
                textColor: Colors.white,
                onPressed: () {
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => AnimPage()));

                  Navigator.push(context, PageRouteBuilder(pageBuilder:
                      (BuildContext context, Animation animation,
                          Animation secondaryAnimation) {
                    return ScaleTransition(
                        scale: animation,
                        alignment: Alignment.bottomRight,
                        child: AnimPage());
                  }));
                },
                child: Text("Anim Page"),
              ),
            ),
            // HeroDemo
            Container(
              margin: EdgeInsets.only(top: 16),
              child: RaisedButton(
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HeroPageA()));
                },
                child: Text("HeroDemo"),
              ),
            )
          ],
        ),
      ),
    );
  }

  parserJson(){
    var data = '';

    // 解析Json
    var userMap = jsonDecode(data);
    var user = User.fromMap(userMap);

    // 对象转Json
    var userJson = jsonEncode(user);
  }
}
