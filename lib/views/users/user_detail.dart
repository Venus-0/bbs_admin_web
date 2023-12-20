import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/model/bbs_model.dart';
import 'package:bbs_admin_web/model/user_model.dart';
import 'package:bbs_admin_web/utils/event_bus.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:bbs_admin_web/widget/page_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  UserPage({super.key, required this.user});
  UserModel user;
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<BBSModel> _bbsList = [];
  int _page = 1; //当前页
  int _totalPage = 0;
  int _type = 0;
  UniqueKey _switchPageKey = UniqueKey();

  ///获取用户列表
  void getBBSList([String searchName = "", String searchEmail = ""]) async {
    Map _res = await Api.getBBSList(_page, _type);
    if (_res['code'] == 200) {
      _bbsList.clear();
      List<Map<String, dynamic>> _list = List<Map<String, dynamic>>.from(_res['result']['data']);
      for (Map<String, dynamic> _json in _list) {
        _bbsList.add(BBSModel.fromJson(_json));
      }
      _totalPage = _res['result']['page']['total'] ?? 0;
      setState(() {});
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBBSList();
  }

  ///禁用用户
  void onBan() async {
    EasyLoading.show();
    bool _ret = await Api.banUser(widget.user.user_id);
    EasyLoading.dismiss();

    if (_ret) {
      setState(() {
        widget.user.disable_time = DateTime.now();
      });
      eventBus.fire(UserEvent());
    }
  }

  ///启用用户
  void onActive() async {
    EasyLoading.show();
    bool _ret = await Api.activeUser(widget.user.user_id);
    EasyLoading.dismiss();

    if (_ret) {
      setState(() {
        widget.user.disable_time = null;
      });
      eventBus.fire(UserEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    String _getTypeString(int type) {
      if (type == BBSModel.TYPE_POST) return "帖子";
      if (type == BBSModel.TYPE_QUESTION) return "问题";
      if (type == BBSModel.TYPE_WIKI) return "文章";
      return "--";
    }

    Widget _userInfo = Table(
      columnWidths: <int, FlexColumnWidth>{
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(3),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(3),
      },
      children: [
        TableRow(
            decoration: BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: Color(0xFFB3E5FC))),
            ),
            children: [
              Container(
                color: Color(0xff03A9F4).withAlpha(128),
                height: 42,
                child: Text("用户ID"),
                alignment: Alignment.center,
              ),
              Container(
                height: 42,
                child: Text("${widget.user.user_id}"),
                alignment: Alignment.center,
              ),
              Container(
                color: Color(0xff03A9F4).withAlpha(128),
                height: 42,
                child: Text("用户名"),
                alignment: Alignment.center,
              ),
              Container(
                height: 42,
                child: Text("${widget.user.username}"),
                alignment: Alignment.center,
              ),
              Container(
                color: Color(0xff03A9F4).withAlpha(128),
                height: 42,
                child: Text("用户邮箱"),
                alignment: Alignment.center,
              ),
              Container(
                height: 42,
                child: Text("${widget.user.email}"),
                alignment: Alignment.center,
              ),
            ]),
        TableRow(
            decoration: BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: Color(0xFFB3E5FC))),
            ),
            children: [
              Container(
                color: Color(0xff03A9F4).withAlpha(128),
                height: 42,
                child: Text("用户注册时间"),
                alignment: Alignment.center,
              ),
              Container(
                height: 42,
                child:
                    Text("${widget.user.create_time == null ? '--' : DateFormat("yyyy-MM-dd HH:mm:ss").format(widget.user.create_time!)}"),
                alignment: Alignment.center,
              ),
              Container(
                color: Color(0xff03A9F4).withAlpha(128),
                height: 42,
                child: Text("用户等级"),
                alignment: Alignment.center,
              ),
              Container(
                height: 42,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  value: widget.user.rank,
                  items: [DropdownMenuItem(child: Text('普通用户'), value: 0), DropdownMenuItem(child: Text("技术支持"), value: 1)],
                  onChanged: (value) {
                    if (value == null) return;
                    Api.updateUser(widget.user.user_id, {"rank": value}).then((ret) {
                      if (ret) {
                        setState(() {
                          widget.user.rank = value;
                        });
                      }
                    });
                  },
                )),
                alignment: Alignment.center,
              ),
              Container(
                color: Color(0xff03A9F4).withAlpha(128),
                height: 42,
                child: Text("用户禁用时间"),
                alignment: Alignment.center,
              ),
              Container(
                height: 42,
                child: Text(
                    "${widget.user.disable_time == null ? '--' : DateFormat("yyyy-MM-dd HH:mm:ss").format(widget.user.disable_time!)}"),
                alignment: Alignment.center,
              ),
            ])
      ],
    );

    Widget _posts = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: <int, FlexColumnWidth>{
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(2),
        6: FlexColumnWidth(2),
        7: FlexColumnWidth(1),
      },
      children: [
        TableRow(children: [
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("ID")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("标题")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("类型")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("点赞数")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("评论数")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("发帖时间")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("最后一次评论时间")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("详情")),
        ]),
        ...List.generate(_bbsList.length, (index) {
          DateTime? _deleteTime = _bbsList[index].delete_time;
          return TableRow(decoration: BoxDecoration(color: index % 2 == 0 ? Color(0xFFD8D8D8).withAlpha(128) : null), children: [
            Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: 32),
                child: Text(
                  "${_bbsList[index].id} ${_deleteTime == null ? '' : '(已删除)'}",
                  style: TextStyle(
                    color: _deleteTime == null ? null : Color(0xFFe74c3c),
                    decoration: _deleteTime == null ? null : TextDecoration.lineThrough,
                    height: 1.0,
                  ),
                )),
            Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("${_bbsList[index].title}")),
            Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: 32),
                child: Text("${_getTypeString(_bbsList[index].question_type)}")),
            Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("${_bbsList[index].up_count}")),
            Container(
                alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("${_bbsList[index].reply_count}")),
            Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: 32),
                child: Text("${_bbsList[index].create_time ?? '--'}")),
            Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: 32),
                child: Text("${_bbsList[index].last_reply_time ?? '--'}")),
            Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: 32),
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notes,
                      color: Color(0xFF3498db),
                    ))),
          ]);
        })
      ],
    );

    Widget _postsSwitch = PageSwitch(
        key: _switchPageKey,
        page: _page,
        totalPage: _totalPage,
        onChanged: (page) {
          setState(() {
            _page = page;
          });
          getBBSList();
        });

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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "用户信息",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Buttons.getButton(
                  widget.user.disable_time == null ? "禁用用户" : "启用用户",
                  () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("提示"),
                        content: Text("是否${widget.user.disable_time == null ? '禁用' : '启用'}该账户?"),
                        actions: [
                          Buttons.getButton("是", () {
                            Navigator.pop(context);
                            if (widget.user.disable_time == null) {
                              onBan();
                            } else {
                              onActive();
                            }
                          }, textColor: Color(0xFFe74c3c)),
                          Buttons.getButton("否", () {
                            Navigator.pop(context);
                          }),
                        ],
                      ),
                    );
                  },
                  fillColor: widget.user.disable_time == null ? Color(0xFFe74c3c) : Color(0xFF2ecc71),
                  textColor: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 10),
            _userInfo,
            SizedBox(height: 10),
            Text(
              "用户发帖详情",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _posts,
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _postsSwitch,
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
