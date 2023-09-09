import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/model/bbs_model.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:bbs_admin_web/widget/page_switch.dart';
import 'package:flutter/material.dart';

class PostManagePage extends StatefulWidget {
  const PostManagePage({super.key});

  @override
  State<PostManagePage> createState() => _PostManagePageState();
}

class _PostManagePageState extends State<PostManagePage> {
  List<BBSModel> _bbsList = [];
  int _page = 1; //当前页
  int _totalPage = 0;
  int _type = 0;
  UniqueKey _switchPageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  ///获取用户列表
  void getUserList([String searchName = "", String searchEmail = ""]) async {
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
  Widget build(BuildContext context) {
    Widget _buttonBar = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 120,
          height: 36,
          decoration: BoxDecoration(border: Border.all(color: Color(0xFFD8D8D8)), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  isExpanded: true,
                  isDense: true,
                  value: _type,
                  items: [
                    DropdownMenuItem(
                      alignment: Alignment.center,
                      child: Text("全部", textAlign: TextAlign.center),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      alignment: Alignment.center,
                      child: Text("问题", textAlign: TextAlign.center),
                      value: BBSModel.TYPE_QUESTION,
                    ),
                    DropdownMenuItem(
                      alignment: Alignment.center,
                      child: Text("文章", textAlign: TextAlign.center),
                      value: BBSModel.TYPE_WIKI,
                    ),
                    DropdownMenuItem(
                      alignment: Alignment.center,
                      child: Text("帖子", textAlign: TextAlign.center),
                      value: BBSModel.TYPE_POST,
                    ),
                  ],
                  onChanged: (type) {
                    setState(() {
                      _type = type ?? 0;
                      _page = 1;
                      _switchPageKey = UniqueKey();
                    });
                    getUserList();
                  })),
        )
      ],
    );

    String _getTypeString(int type) {
      if (type == BBSModel.TYPE_POST) return "帖子";
      if (type == BBSModel.TYPE_QUESTION) return "问题";
      if (type == BBSModel.TYPE_WIKI) return "文章";
      return "--";
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
                      Container(
                          alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("${_bbsList[index].title}")),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: Text("${_getTypeString(_bbsList[index].question_type)}")),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: Text("${_bbsList[index].up_count}")),
                      Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(minHeight: 32),
                          child: Text("${_bbsList[index].reply_count}")),
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
