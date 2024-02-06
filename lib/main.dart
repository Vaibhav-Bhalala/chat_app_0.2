import 'package:chat_app/Modules/View/Home_Screen/home_screen.dart';
import 'package:chat_app/Modules/View/Intro_screen/Intro_screen.dart';
import 'package:chat_app/Modules/View/sign_up_screen/Model/signup_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Modules/View/Chat_screen/chat_screen.dart';
import 'Modules/View/LogIn_Screen/LogIn.dart';
import 'Modules/View/sign_up_screen/signup_screen.dart';
import 'Modules/View/splash_screen/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isvisited = preferences.getBool("isIntroVisited") ?? false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
    ),
    initialRoute: (isvisited) ? '/splash' : '/',
    getPages: [
      GetPage(name: '/', page: () => intropage()),
      GetPage(name: '/splash', page: () => SplashScreen()),
      GetPage(name: '/login', page: () => LoginScreen()),
      GetPage(name: '/signup', page: () => SignUp_Page()),
      GetPage(name: '/home', page: () => Home_Screen()),
      GetPage(
        name: '/chat',
        page: () => Chat_Screen(),
      ),
    ],
  ));
}
