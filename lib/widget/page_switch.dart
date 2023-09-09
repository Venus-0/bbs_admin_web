import 'dart:math';

import 'package:bbs_admin_web/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageSwitch extends StatefulWidget {
  const PageSwitch({super.key, required this.page, required this.totalPage, required this.onChanged});
  final int page;
  final int totalPage;
  final ValueChanged<int> onChanged;

  @override
  State<PageSwitch> createState() => _PageSwitchState();
}

class _PageSwitchState extends State<PageSwitch> {
  late int total; //总数
  late int index; //页码

  late TextEditingController _controller; //跳转输入框控制器
  TextStyle _textStyle = TextStyle(color: Color(0xFF26434D));
  RegExp _numExp = RegExp(r'[0-9]'); //纯数字

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total = widget.totalPage;
    index = widget.page;
    total = max(1, total);
    index = max(1, index);
    _controller = TextEditingController();
  }

  void next() {
    if (index == total) return;
    setState(() {
      index++;
    });
    widget.onChanged(index);
  }

  void preview() {
    if (index == 1) return;
    setState(() {
      index--;
    });
    widget.onChanged(index);
  }

  void jumpTo() {
    int _jumpPage = int.tryParse(_controller.text) ?? -1;
    if (_jumpPage == -1 || _jumpPage > total) return;
    widget.onChanged(_jumpPage);
    setState(() {
      index = _jumpPage;
    });
  }

  void setTotla(int _total) {
    total = max(1, _total);
    if (index >= total) {
      index = 1;
    }
    setState(() {});
  }

  void setIndex(int _index) {
    index = max(1, index);
    setState(() {
      index = _index;
      if (index >= total) {
        index = total;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ///大于7页中间加省略号

    ///小于7页全部显示
    Widget getPages() {
      List<int> showPages = []; //显示的页码， -1为省略号
      if (total <= 7) {
        //7页一下全部显示
        showPages = List.generate(total, (index) => index + 1);
      } else {
        //增加省略号
        showPages.add(1);
        if (index < 4) {
          //页码在前四页或后三页只加一个省略号
          for (int i = 2; i <= 4; i++) {
            showPages.add(i);
          }
          showPages.addAll([-1, total]);
        } else if (total - index < 3) {
          showPages.add(-1);
          for (int i = total - 3; i <= total; i++) {
            showPages.add(i);
          }
        } else {
          showPages.add(-1);
          for (int i = index - 1; i <= index + 1; i++) {
            showPages.add(i);
          }
          showPages.add(-1);
          showPages.add(total);
        }
      }

      return Row(
        children: List.generate(showPages.length, (index) {
          if (showPages[index] == -1) {
            return Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.symmetric(horizontal: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                "...",
                style: TextStyle(color: Color(0xFF26434D)),
              ),
            );
          } else {
            bool _isSelect = this.index == showPages[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  this.index = showPages[index];
                });
                widget.onChanged(showPages[index]);
              },
              child: Container(
                width: 28,
                height: 28,
                margin: EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _isSelect ? Color(0xFF5196FF) : Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  showPages[index].toString(),
                  style: TextStyle(color: _isSelect ? Colors.white : Color(0xFF26434D)),
                ),
              ),
            );
          }
        }),
      );
    }

    return Container(
      height: 28,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Buttons.getButton('上一页', preview, textColor: Color(0xFF5196FF)),
          SizedBox(width: 7),
          getPages(),
          SizedBox(width: 7),
          Buttons.getButton('下一页', next, textColor: Color(0xFF5196FF)),
          SizedBox(width: 40),
          Text("跳转至", style: _textStyle),
          SizedBox(width: 7),
          Container(
            width: 57,
            height: 28,
            child: TextField(
              style: _textStyle,
              textAlign: TextAlign.center,
              controller: _controller,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF979797)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF979797)),
                  ),
                  contentPadding: EdgeInsetsDirectional.zero),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter(_numExp, allow: true)],
            ),
          ),
          SizedBox(width: 7),
          Text("页", style: _textStyle),
          SizedBox(width: 23),
          Buttons.getButton('跳转', jumpTo, textColor: Color(0xFF5196FF))
        ],
      ),
    );
  }
}
