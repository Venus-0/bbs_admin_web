import 'package:bbs_admin_web/utils/event_bus.dart';
import 'package:bbs_admin_web/views/home/dashboard_page.dart';
import 'package:bbs_admin_web/views/home/post_manage_page.dart';
import 'package:bbs_admin_web/views/home/user_manage_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  Widget _content = Container();

  final List<Map<String, dynamic>> _routeList = [
    {"title": "概览", "page": DashboardPage(), "index": 0},
    {"title": "用户管理", "page": UserManagePage(), "index": 1},
    {"title": "论坛管理", "page": PostManagePage(), "index": 2},
  ];

  @override
  void initState() {
    super.initState();
    _content = _routeList[_index]['page'];
    eventBus.on<PageClass>().listen((event) {
      setState(() {
        _content = event.page;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventBus.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xFFD8D8D8),
                blurRadius: 10,
                blurStyle: BlurStyle.outer,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "论坛管理后台 V1.0",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: double.infinity,
              width: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFD8D8D8),
                    blurRadius: 10,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    _routeList.length,
                    (index) => RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              _index = index;
                              _content = _routeList[_index]['page'];
                            });
                          },
                          child: Text(
                            _routeList[index]['title'],
                            style: TextStyle(color: _index == index ? Colors.deepPurple : null),
                          ),
                          constraints: BoxConstraints(minHeight: 42, minWidth: 220),
                        )),
              ),
            ),
            Expanded(child: _content)
          ],
        ))
      ],
    ));
  }
}
