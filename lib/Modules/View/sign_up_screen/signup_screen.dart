import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/Globals/globals.dart';
import '../../utils/Helpers/Authentication_Helper/auth_helper.dart';
import 'Model/signup_model.dart';

class SignUp_Page extends StatelessWidget {
  SignUp_Page({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                height: h * .35,
                width: w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("asset/images/signup.gif"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Valid Email";
                        } else {
                          return null;
                        }
                      },
                      controller: Global.signup_email_c,
                      onSaved: (val) {
                        Global.signup_email = val!;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Enter Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Valid Password";
                        } else {
                          return null;
                        }
                      },
                      controller: Global.signup_pass_c,
                      onSaved: (val) {
                        Global.signup_pass = val!;
                      },
                      obscureText: Global.show,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.remove_red_eye),
                        hintText: "Enter Password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          SignUp data = SignUp(
                            email: Global.signup_email!,
                            password: Global.signup_pass!,
                          );

                          Map<String, dynamic> res =
                              await Auth_helper.auth_helper.signUp(data: data);

                          if (res['user'] != null) {
                            Get.offNamedUntil("/login", (routes) => false);
                          }
                          Global.signup_pass_c.clear();
                          Global.signup_email_c.clear();
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
