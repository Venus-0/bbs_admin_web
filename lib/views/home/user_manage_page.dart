import 'dart:async';

import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/model/user_model.dart';
import 'package:bbs_admin_web/utils/event_bus.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:bbs_admin_web/views/users/add_user.dart';
import 'package:bbs_admin_web/views/users/user_detail.dart';
import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:bbs_admin_web/widget/page_switch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserManagePage extends StatefulWidget {
  const UserManagePage({super.key});

  @override
  State<UserManagePage> createState() => _UserManagePageState();
}

class _UserManagePageState extends State<UserManagePage> {
  List<UserModel> _userList = [];
  int _page = 1; //当前页
  int _totalPage = 0;
  bool _showSearch = false; //是否显示搜索

  TextEditingController _userNameSearchController = TextEditingController();
  TextEditingController _userEmailSearchController = TextEditingController();

  UniqueKey _switchPageKey = UniqueKey();
  late StreamSubscription userListener;
  @override
  void initState() {
    super.initState();
    userListener = eventBus.on<UserEvent>().listen((event) {
      getUserList();
    });
    getUserList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userListener.cancel();
  }

  ///获取用户列表
  void getUserList([String searchName = "", String searchEmail = ""]) async {
    Map _res = await Api.getUserList(_page, findEmail: searchEmail, findName: searchName, pageSize: 15);
    if (_res['code'] == 200) {
      _userList.clear();
      List<Map<String, dynamic>> _list = List<Map<String, dynamic>>.from(_res['result']['data']);
      for (Map<String, dynamic> _json in _list) {
        _userList.add(UserModel.fromJson(_json));
      }
      _totalPage = _res['result']['page']['total'] ?? 0;
      _switchPageKey = UniqueKey();
      setState(() {});
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
    }
  }

  @override
  Widget build(BuildContext context) {
    String? formatDate(DateTime? date) {
      if (date == null) return null;
      return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    }

    Widget _buttonBar = Row(
      children: [
        Buttons.getButton("筛选", () {
          setState(() {
            _showSearch = !_showSearch;
          });
        }, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
        SizedBox(width: 20),
        Buttons.getButton("添加用户", () {
          eventBus.fire(PageClass(AddUser()));
        }, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
      ],
    );

    Widget _search = AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: double.infinity,
      height: _showSearch ? 80 : 0,
      child: Column(
        children: _showSearch
            ? [
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "姓名:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 200,
                          height: 32,
                          child: TextField(
                            controller: _userNameSearchController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              hintText: "姓名",
                              hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 30),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "邮箱:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 200,
                          height: 32,
                          child: TextField(
                            controller: _userEmailSearchController,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              hintText: "邮箱",
                              hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Buttons.getButton("搜索", () {
                          String _searchName = _userNameSearchController.text;
                          String _searchEmail = _userEmailSearchController.text;
                          _page = 1;
                          _switchPageKey = UniqueKey();
                          getUserList(_searchName, _searchEmail);
                          setState(() {});
                        }, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
                        SizedBox(width: 20),
                        Buttons.getButton("重置", () {
                          _userNameSearchController.clear();
                          _userEmailSearchController.clear();
                          _page = 1;
                          _switchPageKey = UniqueKey();
                          getUserList();
                          setState(() {});
                        }, fillColor: Color(0xFFe74c3c), textColor: Colors.white),
                      ],
                    ),
                  ],
                ),
                Divider(),
              ]
            : [],
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 16, left: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 8,
          color: Color(0xFFD8D8D8),
          blurStyle: BlurStyle.outer,
        )
      ]),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          _buttonBar,
          Divider(),
          _search,
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
                  6: FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("用户ID")),
                    Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("用户昵称")),
                    Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("用户邮箱")),
                    Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("等级")),
                    Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("注册时间")),
                    Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("最后一次登陆时间")),
                    Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("详情")),
                  ]),
                  ...List.generate(_userList.length, (index) {
                    DateTime? _deleteTime = _userList[index].disable_time;
                    return TableRow(decoration: BoxDecoration(color: index % 2 == 0 ? Color(0xFFD8D8D8).withAlpha(128) : null), children: [
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: Text("${_userList[index].user_id}")),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: Text(
                            "${_userList[index].username} ${_deleteTime == null ? '' : '(已禁用)'}",
                            style: TextStyle(
                              color: _deleteTime == null ? null : Color(0xFFe74c3c),
                              decoration: _deleteTime == null ? null : TextDecoration.lineThrough,
                              height: 1.0,
                            ),
                          )),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: Text("${_userList[index].email}")),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: Text("${_userList[index].rank == 1 ? '技术支持' : '普通用户'}")),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: Text("${formatDate(_userList[index].create_time) ?? '--'}")),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: Text("${formatDate(_userList[index].update_time) ?? '--'}")),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: IconButton(
                              onPressed: () {
                                eventBus.fire(PageClass(UserPage(user: _userList[index])));
                              },
                              icon: Icon(
                                Icons.notes,
                                color: Color(0xFF3498db),
                              ))),
                    ]);
                  })
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          PageSwitch(
              key: _switchPageKey,
              page: _page,
              totalPage: _totalPage,
              onChanged: (page) {
                setState(() {
                  _page = page;
                });
                getUserList();
              })
        ],
      ),
    );
  }
}
