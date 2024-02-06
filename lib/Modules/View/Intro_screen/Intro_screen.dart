import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Globals/globals.dart';

class intropage extends StatefulWidget {
  const intropage({super.key});

  @override
  State<intropage> createState() => _intropageState();
}

class _intropageState extends State<intropage> {
  final List pages = [
    {
      'image': 'asset/images/1.png',
      'title': 'Welcome to Chat App',
      'description':
          'Effortlessly Chat With Your Contacts And Get Connected With anyone Easily...'
    },
    {
      'image': 'asset/images/2.png',
      'title': 'Explore Features',
      'description':
          'share New Things by sending photos and get informative about thier life too with our exclusive features...'
    },
    {
      'image': 'asset/images/3.png',
      'title': 'Let\'s chat and Get Started...',
      'description': 'Let\'s get started!'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            // color: Colors.lightBlueAccent,
          ),
          PageView.builder(
            controller: Global.pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                Global.currentPageIndex = index;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    height: Get.height * 0.5,
                    width: Get.width * 0.5,
                    child: Image.asset(
                      pages[index]['image'],
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Text(pages[index]['title'],
                      style: GoogleFonts.robotoSlab(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent)),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      pages[index]['description'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoSlab(
                          fontSize: 16.0, color: Colors.blueAccent),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 50.0,
            right: 160.0,
            child: Row(
              children: [
                for (int i = 0; i < pages.length; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == Global.currentPageIndex
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 25.0,
            right: 16.0,
            child: (Global.currentPageIndex == pages.length - 1)
                ? TextButton(
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setBool("isIntroVisited", true);
                      Get.offNamed("/splash");
                    },
                    child: Text(
                      "Done",
                      style: GoogleFonts.robotoSlab(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ))
                : IconButton(
                    onPressed: () {
                      Global.pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: const Icon(
                      Icons.chevron_right,
                      color: Colors.blueAccent,
                      size: 45,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
