import 'dart:convert';

import 'package:bbs_admin_web/http/http.dart';
import 'package:bbs_admin_web/model/admin_user_model.dart';
import 'package:bbs_admin_web/model/comment_model.dart';
import 'package:bbs_admin_web/model/notice_model.dart';
import 'package:bbs_admin_web/utils/toast.dart';
import 'package:flutter/foundation.dart';

///接口方法
class Api {
  static const HOST = "http://127.0.0.1:8080"; //主域名

  static const CHECK_LOGIN = HOST + "/api/admin/checkLogin"; //检查登录接口
  static const LOGIN = HOST + "/api/admin/loginAdmin"; //登录接口

  static const GET_USER_LIST = HOST + "/api/admin/getUserList"; //获取用户列表
  static const GET_BBS_LIST = HOST + "/api/admin/getPostList"; //获取帖子列表
  static const ADD_USER = HOST + "/api/admin/addUser"; //添加用户
  static const BAN_USER = HOST + "/api/admin/banUser"; //禁用用户
  static const ACTIVE_USER = HOST + "/api/admin/activeUser"; //启用用户
  static const GET_USER_POST = HOST + "/api/admin/getUserPosts"; //获取用户发帖列表
  static const UPDATE_USER = HOST + "/api/admin/updateUser"; //更新用户
  static const GET_POST_COMMENT = HOST + "/api/admin/getPostComment"; //获取用户发帖列表
  static const GET_ADMIN_LIST = HOST + "/api/admin/getAdminUser"; //获取管理员列表
  static const EDIT_ADMIN_USER = HOST + '/api/admin/modifyAdminUser'; //修改管理员
  static const ADD_ADMIN = HOST + "/api/admin/addAdmin"; //添加管理员

  static const ADD_NOTICE = HOST + '/api/admin/addNotice'; //添加公告
  static const DELETE_NOTICE = HOST + '/api/admin/deleteNotice'; //删除公告
  static const GET_NOTICE = HOST + '/api/user/getNotice'; //获取公告

  static const SET_POST_TOP = HOST + '/api/admin/setPostTop'; //加精
  static const UN_SET_POST_TOP = HOST + '/api/admin/unsetPostTop'; //取消加精
  static const SET_POST_RECOMMAND = HOST + '/api/admin/setPostRecommand'; //推荐
  static const UN_SET_POST_RECOMMAND = HOST + '/api/admin/unsetPostRecommand'; //取消推荐
  static const DELETE_POST = HOST + '/api/admin/deletePost'; //删帖
  static const ACTIVE_POST = HOST + '/api/admin/activePost'; //恢复帖子

  static const RESET_ADMIN_PASSWORD = HOST + '/api/admin/resetPassword'; //密码重置(超管)
  static const RESET_PASSWORD = HOST + '/api/admin/modifyPassword'; //修改密码

  static const GET_TOTAL_USER = HOST + '/api/admin/getTotalUser'; //用户总数
  static const GET_TOTAL_COMMENT = HOST + '/api/admin/getTotlaComment'; //评论总数
  static const GET_TOTAL_POST = HOST + '/api/admin/getTotalPosts'; //帖子总数
  static const GET_POST_RANK = HOST + '/api/admin/getPostRank'; //发帖排行
  static const GET_COMMENT_RANK = HOST + '/api/admin/getCommentRank'; //评论排行
  static const GET_POST_LIKE_RANK = HOST + '/api/admin/getPostLikeRank'; //帖子点赞排行
  static const GET_COMMENT_LIKE_RANK = HOST + '/api/admin/getCommentLikeRank'; //评论点赞排行

  ///登录
  static Future<Map> login(String id, String pwd) async {
    Map _res = await Http.request(LOGIN, HttpType.POST, {
      "id": id,
      "pwd": pwd,
    });
    return _res;
  }

  ///检查登录
  static Future<Map> checkLogin() async {
    Map _res = await Http.request(CHECK_LOGIN, HttpType.GET, null);
    return _res;
  }

  ///获取用户列表
  static Future<Map> getUserList(int page, {int pageSize = 10, String findEmail = "", String findName = ""}) async {
    Map<String, dynamic> _postData = {
      "page": page,
      "pageSize": pageSize,
      "email": findEmail,
      "username": findName,
    };

    return await Http.request(GET_USER_LIST, HttpType.POST, _postData);
  }

  ///获取帖子列表
  static Future<Map> getBBSList(int page, int type, {int pageSize = 10}) async {
    Map<String, dynamic> _postData = {
      "type": type,
      "page": page,
      "pageSize": pageSize,
    };

    return await Http.request(GET_BBS_LIST, HttpType.POST, _postData);
  }

  static Future<bool> addUser(String name, String email, String password, int rank) async {
    Map _res = await Http.request(ADD_USER, HttpType.POST, {"userName": name, "email": email, "password": password, "rank": rank});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///禁用用户
  static Future<bool> banUser(int user_id) async {
    Map _res = await Http.request(BAN_USER, HttpType.GET, {"user_id": user_id});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///启用用户
  static Future<bool> activeUser(int user_id) async {
    Map _res = await Http.request(ACTIVE_USER, HttpType.GET, {"user_id": user_id});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  static Future<bool> updateUser(int userId, Map<String, dynamic> modify) async {
    Map _res = await Http.request(UPDATE_USER, HttpType.POST, {"user_id": userId, "modifyJson": jsonEncode(modify)});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///获取帖子的评论
  static Future<List<CommentModel>> getPostComments(int postId, int page, {int pageSize = 10}) async {
    Map _res = await Http.request(GET_POST_COMMENT, HttpType.POST, {"comment_id": postId, "page": page, "pageSize": pageSize});
    List<CommentModel> _list = [];
    if (_res['code'] == 200) {
      Map _result = _res['result'];
      for (Map<String, dynamic> _json in _result['list'] ?? []) {
        _list.add(CommentModel.fromJson(_json));
      }
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
    }
    return _list;
  }

  ///获取管理员列表
  static Future<List<AdminUserModel>> getAdminUserList() async {
    Map _res = await Http.request(GET_ADMIN_LIST, HttpType.GET, null);
    List<AdminUserModel> _list = [];
    if (_res['code'] == 200) {
      for (final json in _res['result']['list']) {
        AdminUserModel _admin = AdminUserModel.fromJson(json);
        _list.add(_admin);
      }
    }
    return _list;
  }

  ///加精
  static Future<bool> topPost(int id) async {
    Map _res = await Http.request(SET_POST_TOP, HttpType.POST, {"id": id});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///取消加精
  static Future<bool> untopPost(int id) async {
    Map _res = await Http.request(UN_SET_POST_TOP, HttpType.POST, {"id": id});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///推荐
  static Future<bool> recommandPost(int id) async {
    Map _res = await Http.request(SET_POST_RECOMMAND, HttpType.POST, {"id": id});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///取消推荐
  static Future<bool> unrecommandPost(int id) async {
    Map _res = await Http.request(UN_SET_POST_RECOMMAND, HttpType.POST, {"id": id});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///删帖
  static Future<bool> deletePost(int id) async {
    Map _res = await Http.request(DELETE_POST, HttpType.POST, {"id": id});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///恢复帖子
  static Future<bool> activePost(int id) async {
    Map _res = await Http.request(ACTIVE_POST, HttpType.POST, {"id": id});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///修改管理员
  static Future<bool> modifyAdminUser(int adminID, Map<String, dynamic> modify) async {
    Map _res = await Http.request(EDIT_ADMIN_USER, HttpType.POST, {"admin_id": adminID, "modify": jsonEncode(modify)});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///重置密码
  static Future<bool> resetPassword(int adminId, String password) async {
    Map _res = await Http.request(RESET_ADMIN_PASSWORD, HttpType.POST, {"admin_id": adminId, "reset_password": password});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  //修改密码
  static Future<bool> modifyPassword(String oldPassword, String newPassword) async {
    Map _res = await Http.request(RESET_PASSWORD, HttpType.POST, {"old_password": oldPassword, "new_password": newPassword});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///添加管理员
  static Future<bool> addAdminUser(String name, String password) async {
    Map _res = await Http.request(ADD_ADMIN, HttpType.POST, {"name": name, "password": password});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///用户总数
  static Future<int> getTotalUser() async {
    Map _res = await Http.request(GET_TOTAL_USER, HttpType.GET, null);
    int total = 0;
    if (_res['code'] == 200) {
      total = _res['result']['count'];
    }
    return total;
  }

  static Future<int> getTotalComment() async {
    Map _res = await Http.request(GET_TOTAL_COMMENT, HttpType.GET, null);
    int total = 0;
    if (_res['code'] == 200) {
      total = _res['result']['count'];
    }
    return total;
  }

  ///帖子总数
  static Future<int> getTotalPost(int type) async {
    Map _res = await Http.request(GET_TOTAL_POST, HttpType.GET, {"type": type});
    int total = 0;
    if (_res['code'] == 200) {
      total = _res['result']['count'];
    }
    return total;
  }

  ///发帖排行
  static Future<List<Map<String, dynamic>>> getPostRank() async {
    Map _res = await Http.request(GET_POST_RANK, HttpType.GET, null);
    List<Map<String, dynamic>> list = [];
    if (_res['code'] == 200) {
      final result = _res['result'];
      list = List<Map<String, dynamic>>.from(result['count']);
    }
    return list;
  }

  ///评论排行
  static Future<List<Map<String, dynamic>>> getCommentRank() async {
    Map _res = await Http.request(GET_COMMENT_RANK, HttpType.GET, null);
    List<Map<String, dynamic>> list = [];
    if (_res['code'] == 200) {
      final result = _res['result'];
      list = List<Map<String, dynamic>>.from(result['count']);
    }
    return list;
  }

  ///帖子点赞排行
  static Future<List<Map<String, dynamic>>> getPostLikeRank() async {
    Map _res = await Http.request(GET_POST_LIKE_RANK, HttpType.GET, null);
    List<Map<String, dynamic>> list = [];
    if (_res['code'] == 200) {
      final result = _res['result'];
      list = List<Map<String, dynamic>>.from(result['count']);
    }
    return list;
  }

  ///评论点赞排行
  static Future<List<Map<String, dynamic>>> getCommentLikeRank() async {
    Map _res = await Http.request(GET_COMMENT_LIKE_RANK, HttpType.GET, null);
    List<Map<String, dynamic>> list = [];
    if (_res['code'] == 200) {
      final result = _res['result'];
      list = List<Map<String, dynamic>>.from(result['count']);
    }
    return list;
  }

  ///获取公告
  static Future<NoticeModel?> getNotice() async {
    Map _res = await Http.request(GET_NOTICE, HttpType.GET, null);
    NoticeModel? _notice;
    if ((_res['result'] ?? {}).isNotEmpty) {
      _notice = NoticeModel.fromJson(_res['result']);
    }
    return _notice;
  }

  ///添加公告
  static Future<bool> addNotice(String title, String content, Uint8List? image) async {
    String imageStr = "";
    if (image != null) {
      imageStr = base64Encode(image);
    }

    Map _res = await Http.request(ADD_NOTICE, HttpType.POST, {"title": title, "content": content, "image": imageStr});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }

  ///删除公告
  static Future<bool> deleteNotice(int id) async {
    Map _res = await Http.request(DELETE_NOTICE, HttpType.POST, {"id": id});
    if (_res['code'] == 200) {
      return true;
    } else {
      Toast.showToast(_res['msg'] ?? "出错了");
      return false;
    }
  }
}
