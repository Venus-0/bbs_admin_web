import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/model/bbs_model.dart';
import 'package:bbs_admin_web/model/comment_model.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:bbs_admin_web/widget/page_switch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostDetail extends StatefulWidget {
  const PostDetail({super.key, required this.bbs});
  final BBSModel bbs;
  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  List<CommentModel> _commentList = [];
  int _page = 1; //当前页
  int _totalPage = 0;
  int _type = 0;
  UniqueKey _switchPageKey = UniqueKey();

  ///获取评论列表
  void getPostCommentList() async {
    _commentList = await Api.getPostComments(widget.bbs.id, _page);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostCommentList();
  }

  @override
  Widget build(BuildContext context) {
    String _getTypeString(int type) {
      if (type == BBSModel.TYPE_POST) return "帖子";
      if (type == BBSModel.TYPE_QUESTION) return "问题";
      if (type == BBSModel.TYPE_WIKI) return "文章";
      return "--";
    }

    Widget _postInfo = Table(
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
                child: Text("帖子ID"),
                alignment: Alignment.center,
              ),
              Container(
                height: 42,
                child: Text("${widget.bbs.id}"),
                alignment: Alignment.center,
              ),
              Container(
                color: Color(0xff03A9F4).withAlpha(128),
                height: 42,
                child: Text("帖子类型"),
                alignment: Alignment.center,
              ),
              Container(
                height: 42,
                child: Text(_getTypeString(widget.bbs.question_type)),
                alignment: Alignment.center,
              ),
              Container(
                color: Color(0xff03A9F4).withAlpha(128),
                height: 42,
                child: Text("帖子标题"),
                alignment: Alignment.center,
              ),
              Container(
                height: 42,
                child: Text("${widget.bbs.title}"),
                alignment: Alignment.center,
              ),
            ]),
        TableRow(
            decoration: BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: Color(0xFFB3E5FC))),
            ),
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                color: Color(0xff03A9F4).withAlpha(128),
                constraints: BoxConstraints(minHeight: 42),
                child: Text("帖子正文"),
                alignment: Alignment.center,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                constraints: BoxConstraints(minHeight: 42),
                child: Text("${widget.bbs.content}"),
                alignment: Alignment.center,
              ),
              Container(),
              Container(),
              Container(),
              Container(),
            ]),
        TableRow(children: [
          Container(
            color: Color(0xff03A9F4).withAlpha(128),
            height: 42,
            child: Text("发帖时间"),
            alignment: Alignment.center,
          ),
          Container(
            height: 42,
            child: Text("${widget.bbs.create_time == null ? '--' : DateFormat("yyyy-MM-dd HH:mm:ss").format(widget.bbs.create_time!)}"),
            alignment: Alignment.center,
          ),
          Container(
            color: Color(0xff03A9F4).withAlpha(128),
            height: 36,
            child: Text("帖子删除时间"),
            alignment: Alignment.center,
          ),
          Container(
            height: 42,
            child: Text("${widget.bbs.delete_time == null ? '--' : DateFormat("yyyy-MM-dd HH:mm:ss").format(widget.bbs.delete_time!)}"),
            alignment: Alignment.center,
          ),
          Container(
            color: Color(0xff03A9F4).withAlpha(128),
            height: 36,
            child: Text("帖子最后回复时间"),
            alignment: Alignment.center,
          ),
          Container(
            height: 42,
            child: Text(
                "${widget.bbs.last_reply_time == null ? '--' : DateFormat("yyyy-MM-dd HH:mm:ss").format(widget.bbs.last_reply_time!)}"),
            alignment: Alignment.center,
          ),
        ])
      ],
    );

    Widget _comments = Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: <int, FlexColumnWidth>{
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(2),
      },
      children: [
        TableRow(children: [
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("ID")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("评论")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("点赞数")),
          Container(alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("评论时间")),
        ]),
        ...List.generate(_commentList.length, (index) {
          DateTime? _deleteTime = _commentList[index].delete_time;
          return TableRow(decoration: BoxDecoration(color: index % 2 == 0 ? Color(0xFFD8D8D8).withAlpha(128) : null), children: [
            Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: 32),
                child: Text(
                  "${_commentList[index].id} ${_deleteTime == null ? '' : '(已删除)'}",
                  style: TextStyle(
                    color: _deleteTime == null ? null : Color(0xFFe74c3c),
                    decoration: _deleteTime == null ? null : TextDecoration.lineThrough,
                    height: 1.0,
                  ),
                )),
            Container(
                alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("${_commentList[index].comment}")),
            Container(
                alignment: Alignment.center, constraints: BoxConstraints(minHeight: 32), child: Text("${_commentList[index].up_count}")),
            Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minHeight: 32),
                child: Text("${_commentList[index].create_time ?? '--'}")),
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
          getPostCommentList();
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
                  "帖子信息",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...widget.bbs.delete_time == null
                    ? [
                        Buttons.getButton(
                          "删除帖子",
                          () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("提示"),
                                content: Text("是否删除该贴?"),
                                actions: [
                                  Buttons.getButton("是", () async {}, textColor: Color(0xFFe74c3c)),
                                  Buttons.getButton("否", () {
                                    Navigator.pop(context);
                                  }),
                                ],
                              ),
                            );
                          },
                          fillColor: Color(0xFFe74c3c),
                          textColor: Colors.white,
                        ),
                      ]
                    : [Container()]
              ],
            ),
            SizedBox(height: 10),
            _postInfo,
            SizedBox(height: 10),
            Text(
              "评论信息",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _comments,
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_postsSwitch],
            )
          ],
        ),
      ),
    );
  }
}
