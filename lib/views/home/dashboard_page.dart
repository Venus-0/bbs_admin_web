import 'package:bbs_admin_web/http/api.dart';
import 'package:bbs_admin_web/model/bbs_model.dart';
import 'package:bbs_admin_web/model/global_model.dart';
import 'package:bbs_admin_web/model/notice_model.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _totalUser = 0; //用户数量
  int _totalBBS = 0; //帖子数量
  int _totalWIKI = 0; //文章数量
  int _totalQuestion = 0; //问题数量
  int _totalPost = 0; //总帖子数量
  int _totalComment = 0; //帖子数量
  List<Map<String, dynamic>> _postType = []; //帖子分布
  List<Map<String, dynamic>> _postRank = []; //发帖排行
  List<Map<String, dynamic>> _commentRank = []; //评论排行
  List<Map<String, dynamic>> _likePostRank = []; //点赞帖子排行
  List<Map<String, dynamic>> _likeCommentRank = []; //点赞评论排行
  NoticeModel? _notice;

  final boxDecoration = BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
    BoxShadow(
      blurRadius: 8,
      color: Color(0xFFD8D8D8),
      blurStyle: BlurStyle.outer,
    )
  ]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotice();
    setTotal();
  }

  void getNotice() async {
    _notice = await Api.getNotice();
    setState(() {});
  }

  void setTotal() async {
    _totalUser = await Api.getTotalUser();
    _totalComment = await Api.getTotalComment();
    _totalBBS = await Api.getTotalPost(BBSModel.TYPE_POST);
    _totalWIKI = await Api.getTotalPost(BBSModel.TYPE_WIKI);
    _totalQuestion = await Api.getTotalPost(BBSModel.TYPE_QUESTION);
    _totalPost = _totalBBS + _totalWIKI + _totalQuestion;

    _postType = [
      {"name": "帖子", "count": _totalBBS},
      {"name": "文章", "count": _totalWIKI},
      {"name": "问题", "count": _totalQuestion},
    ];

    _postRank = await Api.getPostRank();
    _commentRank = await Api.getCommentRank();
    _likePostRank = await Api.getPostLikeRank();
    _likeCommentRank = await Api.getCommentLikeRank();
    setState(() {});
  }

  void onDeleteNotice() async {
    bool _ret = await Api.deleteNotice(_notice!.id);
    if (_ret) {
      getNotice();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSuper = GlobalModel.user?.isSuperAdmin() ?? false;
    void showDeleteNotice() async {
      if (_notice == null) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("提示"),
          content: Text("是删除当前公告?"),
          actions: [
            Buttons.getButton("是", () {
              onDeleteNotice();
              Navigator.pop(context);
            }, textColor: Color(0xFFe74c3c)),
            Buttons.getButton("否", () {
              Navigator.pop(context);
            }),
          ],
        ),
      );
    }

    void show() {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Container(
                  decoration: boxDecoration,
                  width: 500,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    children: [
                      ..._notice!.getImage() == null
                          ? []
                          : [
                              Expanded(
                                child: Container(
                                  color: Color(0xffd8d8d8),
                                  child: _notice!.getImage(fit: BoxFit.cover),
                                ),
                                flex: 3,
                              )
                            ],
                      Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _notice!.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(_notice!.content),
                                ],
                              ),
                            ),
                          ),
                          flex: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "返回",
                            style: TextStyle(color: Color(0xFF2ecc71)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
    }

    Widget notice = InkWell(
        onTap: () {
          if (_notice == null) {
            AddNotice.showAddNotice(context, getNotice);
          } else {
            show();
          }
        },
        child: Container(
            decoration: BoxDecoration(
              image: _notice?.getImage() == null
                  ? null
                  : DecorationImage(
                      fit: BoxFit.cover,
                      image: _notice!.getImage()!.image,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Color(0xFFD8D8D8),
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
            width: double.infinity,
            height: 120,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: _notice == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...!isSuper
                          ? []
                          : [
                              Icon(
                                Icons.add,
                                color: Color(0xffd8d8d8),
                                size: 36,
                              )
                            ],
                      Text(
                        isSuper ? "添加公告" : "暂无公告",
                        style: TextStyle(color: Color(0xffd8d8d8)),
                      )
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _notice?.title ?? "",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Expanded(child: Text(_notice?.content ?? ""))
                        ],
                      )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                AddNotice.showAddNotice(context, getNotice);
                              },
                              icon: Icon(Icons.add)),
                          IconButton(
                              onPressed: showDeleteNotice,
                              icon: Icon(
                                Icons.delete,
                                color: Color(0xFFe74c3c),
                              ))
                        ],
                      )
                    ],
                  )));

    Widget totalUser = Container(
      decoration: boxDecoration,
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("用户数量"),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff6236FF),
                ),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.person_2_rounded,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              Text(
                _totalUser.toString(),
                style: TextStyle(
                  color: Color(0xff6236FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              )
            ],
          )
        ],
      ),
    );
    Widget totalPost = Container(
      decoration: boxDecoration,
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("帖子数量"),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xffB620E0),
                ),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.web,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              Text(
                _totalPost.toString(),
                style: TextStyle(
                  color: Color(0xffB620E0),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              )
            ],
          )
        ],
      ),
    );

    Widget totalComment = Container(
      decoration: boxDecoration,
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("评论数量"),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff26C8F0),
                ),
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              Text(
                _totalComment.toString(),
                style: TextStyle(
                  color: Color(0xff26C8F0),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              )
            ],
          )
        ],
      ),
    );

    Widget postType = Container(
      decoration: boxDecoration,
      width: double.infinity,
      height: 280,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("帖子分布"),
          Expanded(
              child: _postType.isEmpty
                  ? Container()
                  : SfCircularChart(
                      series: [
                        DoughnutSeries(
                          dataSource: _postType,
                          xValueMapper: (value, x) => x,
                          yValueMapper: (value, y) => value['count'],
                          dataLabelMapper: (value, index) => "${value['name']}${value['count']}",
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                              showZeroValue: false,
                              textStyle: TextStyle(
                                  fontFamily: 'Roboto', fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, color: Colors.black)),
                        )
                      ],
                    ))
        ],
      ),
    );

    Widget postRank = Container(
        decoration: boxDecoration,
        width: double.infinity,
        height: 360,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("发帖排行", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RankItem(
              top: "#",
              name: '用户',
              rank: '发帖数',
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return RankItem(
                    top: "${index + 1}",
                    name: _postRank[index]['name'].toString(),
                    rank: _postRank[index]['count'].toString(),
                  );
                },
                itemCount: _postRank.length,
              ),
            )
          ],
        ));

    Widget commentRank = Container(
        decoration: boxDecoration,
        width: double.infinity,
        height: 360,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("评论排行", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RankItem(
              top: "#",
              name: '用户',
              rank: '评论数',
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return RankItem(
                    top: "${index + 1}",
                    name: _commentRank[index]['name'].toString(),
                    rank: _commentRank[index]['count'].toString(),
                  );
                },
                itemCount: _commentRank.length,
              ),
            )
          ],
        ));

    Widget likePostRank = Container(
        decoration: boxDecoration,
        width: double.infinity,
        height: 360,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("帖子点赞排行", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RankItem(
              top: "#",
              name: '帖子',
              rank: '获赞数',
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return RankItem(
                    top: "${index + 1}",
                    name: _likePostRank[index]['title'].toString(),
                    rank: _likePostRank[index]['count'].toString(),
                  );
                },
                itemCount: _likePostRank.length,
              ),
            )
          ],
        ));

    Widget likeCommentRank = Container(
        decoration: boxDecoration,
        width: double.infinity,
        height: 360,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("评论点赞排行", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RankItem(
              top: "#",
              name: '评论',
              rank: '获赞数',
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return RankItem(
                    top: "${index + 1}",
                    name: _likeCommentRank[index]['title'].toString(),
                    rank: _likeCommentRank[index]['count'].toString(),
                  );
                },
                itemCount: _likeCommentRank.length,
              ),
            )
          ],
        ));

    return Container(
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: notice),
                SizedBox(width: 32),
                Expanded(child: totalUser),
                SizedBox(width: 32),
                Expanded(child: totalPost),
                SizedBox(width: 32),
                Expanded(child: totalComment),
              ],
            ),
            SizedBox(height: 32),
            postType,
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: postRank),
                SizedBox(width: 32),
                Expanded(child: commentRank),
                SizedBox(width: 32),
                Expanded(child: likePostRank),
                SizedBox(width: 32),
                Expanded(child: likeCommentRank),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RankItem extends StatelessWidget {
  const RankItem({super.key, required this.top, required this.name, required this.rank});
  final String top;
  final String name;
  final String rank;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xffd8d8d8)))),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(top),
          SizedBox(width: 20),
          Text(name),
          Spacer(),
          Text(rank),
        ],
      ),
    );
  }
}

class AddNotice extends StatefulWidget {
  const AddNotice({super.key, required this.onAdd});

  final VoidCallback onAdd;

  static void showAddNotice(BuildContext context, VoidCallback onAdd) {
    showDialog(context: context, builder: (context) => AddNotice(onAdd: onAdd));
  }

  @override
  State<AddNotice> createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  TextEditingController _titleController = TextEditingController(); //标题
  TextEditingController _contentController = TextEditingController(); //正文
  Uint8List? image;

  void onAdd() async {
    String _title = _titleController.text;
    String _content = _contentController.text;
    if (_title.isEmpty) {
      Toast.showToast("标题不能为空");
      return;
    }
    if (_content.isEmpty) {
      Toast.showToast("正文不能为空");
      return;
    }
    EasyLoading.show();
    bool _ret = await Api.addNotice(_title, _content, image);
    EasyLoading.dismiss();
    if (_ret) {
      widget.onAdd();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 660,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "添加公告",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("*", style: TextStyle(color: Color(0xFFe74c3c))),
                Text("标题", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: "标题",
                hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
                contentPadding: EdgeInsets.only(left: 12),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("*", style: TextStyle(color: Color(0xFFe74c3c))),
                Text("正文", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLines: 5,
              minLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: "正文",
                hintStyle: TextStyle(color: Color(0xFFD8D8D8)),
              ),
            ),
            SizedBox(height: 10),
            Text("添加图片", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                // if (await Permission.photos.isGranted) {
                FilePickerResult? _result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
                print(_result?.count);

                double fileSize = _result!.files[0].size / 1024 / 1024;
                print("文件大小$fileSize");
                if (fileSize > 5) {
                  Toast.showToast("最大支持上传单张大小5M的图片");
                  return;
                }
                image = _result.files[0].bytes;

                setState(() {});
                // }
              },
              onLongPress: () {
                if (image != null) {
                  setState(() {
                    image = null;
                  });
                }
              },
              child: image == null
                  ? Container(
                      width: 120,
                      height: 120,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffd8d8d8)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Color(0xffd8d8d8),
                      ),
                    )
                  : Container(
                      constraints: BoxConstraints(minWidth: 120, minHeight: 120, maxHeight: 240, maxWidth: 240),
                      child: Image.memory(image!, fit: BoxFit.contain),
                    ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Buttons.getButton("返回", () {
                  Navigator.pop(context);
                }, fillColor: Color(0xFF3498db), textColor: Colors.white),
                SizedBox(width: 30),
                Buttons.getButton("确定", onAdd, fillColor: Color(0xFF2ecc71), textColor: Colors.white),
              ],
            )
          ],
        ),
      ),
    );
  }
}
