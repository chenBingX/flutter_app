import 'package:flutter/material.dart';
import 'package:flutter_app/datas/Page.dart';
import 'package:flutter_app/datas/page_data.dart';
import 'package:flutter_app/pages/anim_page.dart';
import 'package:flutter_app/pages/hero_page1.dart';

class HomePage extends StatelessWidget {
  var pages = <Page>[
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
    Page('ListView Demo', (context) {

    }),
  ];

  final PageData data;

  // 带所需参数的构造函数
  HomePage({Key key, this.data}) : super(key: key);

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
              padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
              child: Text(
                data != null
                    ? "From pre page data：" + data.data
                    : 'There is no data!',
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
}
