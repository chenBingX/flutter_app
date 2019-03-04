import 'package:flutter/material.dart';
import 'package:flutter_app/datas/Page.dart';
import 'package:flutter_app/datas/page_data.dart';
import 'package:flutter_app/pages/anim_page.dart';
import 'package:flutter_app/pages/hero_page1.dart';
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

  var pages;
  var message = 'Welcome!';

  @override
  void initState() {
    // TODO: implement initState
    print("initState");
    pages = <Page>[
      Page('Jump With Data', (context) {
        print("Jump With Data");
      }),
      Page('Animation Page', (context) {
        Navigator.push(context, PageRouteBuilder(pageBuilder:
            (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return ScaleTransition(
              scale: animation,
              alignment: Alignment.bottomRight,
              child: AnimPage());
        }));
      }),
      Page('Hero Demo', (context) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HeroPageA()));
      }),
      Page('', (context){
        var data = PageData('Hi, it\'s Home Page!');
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => MessagePage(data: data))).then((
            result) {
          print('received message');
          setState(() {
            message = result;
          });
        });
      }),
      Page('ListView Demo', (context) {

      }),
    ];

    super.initState();
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
              padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
              child: Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: pages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildItem(context, pages[index], index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  _buildItem(BuildContext context, Page page, int index) {
    return GestureDetector(
        onTap: () => page.action(context),
        child: Container(
          margin: EdgeInsets.only(top: index == 0 ? 8 : 2),
          alignment: Alignment.center,
          color: Colors.white,
          child: SizedBox(
            height: 56,
            child: Center(
              child: Text(
                page.pageName,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ));
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
