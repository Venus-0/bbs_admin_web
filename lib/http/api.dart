import 'package:bbs_admin_web/http/http.dart';
import 'package:bbs_admin_web/model/comment_model.dart';
import 'package:bbs_admin_web/utils/toast.dart';

///接口方法
class Api {
  static const HOST = "http://127.0.0.1:8080"; //主域名

  static const CHECK_LOGIN = HOST + "/api/admin/checkLogin"; //检查登录接口
  static const LOGIN = HOST + "/api/admin/loginAdmin"; //登录接口

  static const GET_USER_LIST = HOST + "/api/admin/getUserList"; //获取用户列表
  static const GET_BBS_LIST = HOST + "/api/admin/getPostList"; //获取帖子列表
  static const BAN_USER = HOST + "/api/admin/banUser"; //禁用用户
  static const ACTIVE_USER = HOST + "/api/admin/activeUser"; //启用用户
  static const GET_USER_POST = HOST + "/api/admin/getUserPosts"; //获取用户发帖列表
  static const GET_POST_COMMENT = HOST + "/api/admin/getPostComment"; //获取用户发帖列表

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

  static Future<Map> getUserList(int page, {int pageSize = 10, String findEmail = "", String findName = ""}) async {
    Map<String, dynamic> _postData = {
      "page": page,
      "pageSize": pageSize,
      "email": findEmail,
      "username": findName,
    };

    return await Http.request(GET_USER_LIST, HttpType.POST, _postData);
  }

  static Future<Map> getBBSList(int page, int type, {int pageSize = 10}) async {
    Map<String, dynamic> _postData = {
      "type": type,
      "page": page,
      "pageSize": pageSize,
    };

    return await Http.request(GET_BBS_LIST, HttpType.POST, _postData);
  }

  static Future<Map> banUser(int user_id) async {
    return await Http.request(BAN_USER, HttpType.GET, {"user_id": user_id});
  }

  static Future<Map> activeUser(int user_id) async {
    return await Http.request(BAN_USER, HttpType.GET, {"user_id": user_id});
  }

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
}
