import 'package:bbs_admin_web/model/admin_user_model.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

EventBus eventBus = EventBus();

class PageClass {
  final Widget page;
  PageClass(this.page);
}

class AdminUser {
  final AdminUserModel adminUser;
  AdminUser(this.adminUser);
}

class UserEvent {}

class PostEvent {}
