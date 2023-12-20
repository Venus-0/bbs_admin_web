import 'package:intl/intl.dart';

class AdminUserModel {
  int admin_id;
  String password;
  String name;
  int rank;
  DateTime? create_time; //用户创建时间
  DateTime? delete_time; //用户禁用时间
  DateTime? login_time; //用户更新时间

  AdminUserModel({
    this.admin_id = 0,
    this.password = '',
    this.name = '',
    this.rank = 0,
    this.create_time,
    this.delete_time,
    this.login_time,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) => AdminUserModel(
        admin_id: json['admin_id'],
        name: json['name'],
        rank: json['rank'],
        create_time: DateTime.tryParse(json['create_time'] ?? ''),
        delete_time: DateTime.tryParse(json['delete_time'] ?? ''),
        login_time: DateTime.tryParse(json['login_time'] ?? ''),
      );

  Map<String, dynamic> toJson() => {
        'admin_id': admin_id,
        'password': password,
        'name': name,
        'rank': rank,
        'create_time': create_time == null ? null : DateFormat("yyyy-MM-dd HH:mm:ss").format(create_time!),
        'delete_time': delete_time == null ? null : DateFormat("yyyy-MM-dd HH:mm:ss").format(delete_time!),
        'login_time': login_time == null ? null : DateFormat("yyyy-MM-dd HH:mm:ss").format(login_time!),
      };
  bool isSuperAdmin() => rank == 1;
}
