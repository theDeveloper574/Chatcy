import 'package:chatcy/controllers/provider/call_his_load_more.dart';
import 'package:chatcy/controllers/services/LocalStorage/local_storage.dart';
import 'package:chatcy/controllers/sign_up_controller.dart';
import 'package:chatcy/screens/home_view.dart';
import 'package:chatcy/screens/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../utils/routes/routes_name.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final logInCon = Get.put<SignUpController>(SignUpController());
  @override
  void initState() {
    callLogin().then((value) {
      print('value called');
      print(value);
      if (value) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.home, (route) => false);
        });
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.logIn, (route) => false);
        });
      }
    });
    // isLogin(context);
    // if (logInCon.isSaved == true) {
    //   // Get.offAll(HomeView());
    //   Future.delayed(const Duration(seconds: 3), () {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, RouteName.home, (route) => false);
    //   });
    // } else {
    //   // Get.offAll(LogInView());
    //   Future.delayed(const Duration(seconds: 3), () {
    //     Navigator.pushNamedAndRemoveUntil(
    //         context, RouteName.logIn, (route) => false);
    //   });
    // }

    FirebaseAuth.instance.currentUser != null
        ? setStatus("online", FirebaseAuth.instance.currentUser!.uid)
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.asset(
            'asset/chat-logo.png',
            color: Colors.white,
            fit: BoxFit.fill,
            scale: 3.2,
          ),
        ),
      ),
    );
  }

  ///set user status
  void setStatus(String status, String uid) {
    FirebaseFirestore.instance
        .collection("usersProfile")
        .doc(uid)
        .update({"status": status});
  }

  Future<bool> callLogin() async {
    return await LocalStorage.getIsLogin();
  }
}
