import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/navigation_model.dart';

class NavigationController extends GetxController {
  NavigationModel navigationModel = NavigationModel(selectedIndex: 0.obs);
  PageController pageController = PageController();
  RxInt Selectedindex = 0.obs;

  void changeTab({required int val}) {
    navigationModel.selectedIndex(val);

    pageController.animateToPage(val,
        duration: Duration(milliseconds: 200), curve: Curves.linear);
    update();
  }

  void setSelectedindex({required int i}) {
    Selectedindex(i);
  }
}
