import 'dart:ui';
import 'package:flutter/material.dart';

class Global {
  static PageController pageController = PageController(initialPage: 0);
  static int currentPageIndex = 0;

  static bool show = true;

  static String? signup_email;
  static String? signup_pass;
  static TextEditingController signup_email_c = TextEditingController();
  static TextEditingController signup_pass_c = TextEditingController();

  static String? email;
  static String? pass;
  static TextEditingController email_c = TextEditingController();
  static TextEditingController pass_c = TextEditingController();
}
