import 'dart:async';

import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/model/admin_user_model.dart';
import 'package:bbs_admin_web/utils/event_bus.dart';
import 'package:bbs_admin_web/views/admin/add_admin.dart';
import 'package:bbs_admin_web/views/admin/admin_detail.dart';
import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminManagePage extends StatefulWidget {
  const AdminManagePage({super.key});

  @override
  State<AdminManagePage> createState() => _AdminManagePageState();
}

class _AdminManagePageState extends State<AdminManagePage> {
  List<AdminUserModel> _adminUserList = [];
  late StreamSubscription adminUserSubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAdminList();
    adminUserSubscription = eventBus.on<AdminUser>().listen((event) {
      int _index = _adminUserList.indexWhere((element) => element.admin_id == event.adminUser.admin_id);
      if (_index != -1) {
        _adminUserList[_index] = event.adminUser;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    adminUserSubscription.cancel();
  }

  void _getAdminList() async {
    _adminUserList = await Api.getAdminUserList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget _buttonBar = Row(
      children: [
        Buttons.getButton("添加管理员", () {
          AddAdmin.showAddAdmin(context, () {
            _getAdminList();
          });
        }, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
      ],
    );

    String? formatDate(DateTime? date) {
      if (date == null) return null;
      return DateFormat("yyyy-MM-dd HH:mm:ss").format(date);
    }

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
          Expanded(
              child: SingleChildScrollView(
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
                4: FlexColumnWidth(3),
                5: FlexColumnWidth(2),
                6: FlexColumnWidth(2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(children: [
                  Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("ID")),
                  Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("昵称")),
                  Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("权限")),
                  Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("添加时间")),
                  Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("上一次登陆时间")),
                  Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("状态")),
                  Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("详情")),
                ]),
                ...List.generate(_adminUserList.length, (index) {
                  DateTime? _deleteTime = _adminUserList[index].delete_time;
                  return TableRow(decoration: BoxDecoration(color: index % 2 == 0 ? Color(0xFFD8D8D8).withAlpha(128) : null), children: [
                    Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(minHeight: 32),
                        child: Text("${_adminUserList[index].admin_id}")),
                    Container(
                        alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text(_adminUserList[index].name)),
                    Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(minHeight: 32),
                        child: Text("${_adminUserList[index].rank == 1 ? '超级管理员' : '普通管理员'}")),
                    Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(minHeight: 32),
                        child: Text("${formatDate(_adminUserList[index].create_time) ?? '--'}")),
                    Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(minHeight: 32),
                        child: Text("${formatDate(_adminUserList[index].login_time) ?? '--'}")),
                    Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(minHeight: 32),
                        child: Text(
                          "${_deleteTime == null ? '正常' : '已删除'}",
                          style: TextStyle(
                            color: _deleteTime == null ? null : Color(0xFFe74c3c),
                            decoration: _deleteTime == null ? null : TextDecoration.lineThrough,
                            height: 1.0,
                          ),
                        )),
                    Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(minHeight: 32),
                        child: TextButton(
                          onPressed: () {
                            eventBus.fire(PageClass(AdminUserDetail(adminUser: _adminUserList[index])));
                          },
                          child: Text("编辑"),
                        )),
                  ]);
                })
              ],
            ),
          ))
        ],
      ),
    );
  }
}
