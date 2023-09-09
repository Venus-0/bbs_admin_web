class AdminUserModel {
  int admin_id;
  String password;
  String name;

  AdminUserModel({
    this.admin_id = 0,
    this.password = '',
    this.name = '',
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) => AdminUserModel(
        admin_id: json['admin_id'],
        password: json['password'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'admin_id': admin_id,
        'password': password,
        'name': name,
      };
}
