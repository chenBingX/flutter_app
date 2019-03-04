import 'package:flutter/material.dart';
import 'package:flutter_app/datas/page_data.dart';
import 'package:flutter_app/pages/anim_page.dart';
import 'package:flutter_app/pages/anim_page2.dart';
import 'package:flutter_app/pages/message_page.dart';
import 'package:flutter_app/pages/test_page.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }

}

class _HomePage extends State<HomePage> {

  var message = 'Welcome!';

  @override
  void initState() {
    // TODO: implement initState
    print("initState");
//    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build HomePage");
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            title:
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TestPage();
                }));
              },
              child: Text('Home Page'),

            )
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
              child: Text(message, style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: RaisedButton(
                textColor: Colors.white,
                onPressed: () {
                  var data = PageData('Hi, it\'s Home Page!');
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MessagePage(data: data))).then((
                      result) {
                    print('received message');
                    setState(() {
                      message = result;
                    });
                  });
                },
                child: Text("Message Page"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: RaisedButton(
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AnimPage()));
                },
                child: Text("Anim Page"),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    print("didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    print("deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("dispose");
    super.dispose();
  }


}
