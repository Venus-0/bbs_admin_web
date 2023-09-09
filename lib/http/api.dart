import 'package:bbs_admin_web/http/http.dart';

///接口方法
class Api {
  static const HOST = "http://127.0.0.1:8080"; //主域名

  static const CHECK_LOGIN = HOST + "/api/admin/checkLogin"; //检查登录接口
  static const LOGIN = HOST + "/api/admin/loginAdmin"; //登录接口

  static const GET_USER_LIST = HOST + "/api/admin/getUserList"; //获取用户列表
  static const GET_BBS_LIST = HOST + "/api/admin/getPostList"; //获取帖子列表

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
}
